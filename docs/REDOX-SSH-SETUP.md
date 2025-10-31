# redox ssh setup guide - ed25519 keys for glow/cursor access

**date**: 12025-10-31--1515--pdt--moon-shatabhisha--asc-pisc00--sun-09h  
**team**: teamcarry11 (t11aq, airbender mode)  
**purpose**: enable ssh access for glow/cursor to connect to redox vm

---

## overview

this guide shows how to:
1. generate ed25519 ssh keys (best practice for redox)
2. add ssh authorized keys to redox iso build
3. install and test russh (rust ssh library)
4. connect from glow/cursor via ssh

**why ed25519?**
- small keys (32 bytes vs 256 bytes for rsa)
- fast crypto operations
- secure (strong as 3072-bit rsa)
- perfect for redox (small system, pure rust)

---

## quick start

**one command setup:**
```bash
./scripts/redox-ssh-setup-complete.sh
```

this will:
- generate ed25519 key if needed
- add it to redox config
- check/install russh recipe
- provide build instructions

---

## step-by-step

### step 1: generate ed25519 ssh key

**on your host machine (ubuntu/mac):**

```bash
# Generate ed25519 key specifically for Redox
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_redox -C "glow@cursor-redox" -N ""

# This creates:
# ~/.ssh/id_ed25519_redox      (private key - keep secret!)
# ~/.ssh/id_ed25519_redox.pub  (public key - goes in Redox)
```

**why ed25519?**
- smallest key size (perfect for minimal systems)
- fastest operations (great for vms)
- secure (cryptographically strong)
- rust-friendly (pure rust implementations available)

---

### step 2: add ssh key to redox config

**automated (recommended):**
```bash
export SSH_KEY_FILE="$HOME/.ssh/id_ed25519_redox.pub"
./scripts/redox-add-ssh-keys.sh
```

**or manual:**
edit `~/gitlab/redox-os/redox/config/x86_64/minimal.toml`:

```toml
[[files]]
path = "/home/user/.ssh/authorized_keys"
data = """
ssh-ed25519 AAAA... your-public-key-here glow@cursor-redox
"""
mode = 0o600
```

**important**: ensure `.ssh` directory exists (redox may create it automatically)

---

### step 3: install russh (rust ssh server)

**russh** is a pure rust ssh implementation - perfect for redox!

**automated:**
```bash
./scripts/redox-install-russh.sh
```

**what this does:**
- creates russh recipe in redox cookbook
- adds russh to minimal config
- generates ed25519 host key
- sets up service configuration

**manual installation:**
1. create recipe at `cookbook/recipes/russh/recipe.toml`
2. add russh to config: `russh = {}`
3. rebuild redox

---

### step 4: rebuild redox with ssh support

```bash
cd ~/gitlab/redox-os/redox

make all CONFIG_NAME=minimal \
  PODMAN_ENV="--env CI=1 --env PATH=/home/poduser/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env PODMAN_BUILD=0"
```

**this will:**
- build russh ssh server
- include your ed25519 public key in authorized_keys
- create ed25519 host key
- prepare ssh service

**build time**: faster than first build (cached dependencies)

---

### step 5: boot redox with ssh port forwarding

```bash
cd ~/gitlab/redox-os/redox

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 1024 \
  -smp 2 \
  -drive file=build/x86_64/minimal/harddrive.img,format=raw \
  -device e1000,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22
```

**what this does:**
- `hostfwd=tcp::2222-:22` forwards host port 2222 to redox port 22
- you can connect via `ssh -p 2222 user@localhost`

---

### step 6: start ssh server in redox

**inside redox vm:**
```ion
# Start russh server
russhd --config /etc/russhd/config.toml &

# Or if russh is managed by init system:
# (russh should start automatically)
```

**verify ssh is running:**
```ion
# Check if russhd process exists
ps aux | grep russhd
```

---

### step 7: connect from glow/cursor

**from your host machine:**
```bash
# Connect using ed25519 key
ssh -p 2222 -i ~/.ssh/id_ed25519_redox user@localhost

# First connection will show host key fingerprint
# Type 'yes' to accept
```

**add to ssh config for convenience:**
```bash
cat >> ~/.ssh/config << EOF

Host redox-vm
    HostName localhost
    Port 2222
    User user
    IdentityFile ~/.ssh/id_ed25519_redox
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null

EOF

# Now connect easily:
ssh redox-vm
```

---

## security considerations

### development vs production

**development (what we're doing):**
- ✅ embedded ssh keys in iso (convenient for dev)
- ✅ single user access (you)
- ✅ local vm (not exposed to internet)
- ✅ ed25519 keys (secure)

**production (different approach):**
- ❌ don't embed keys in iso
- ❌ use proper key management
- ❌ firewall rules
- ❌ ssh key rotation
- ❌ audit logging

**for now**: this is fine for development vms!

---

## troubleshooting

### ssh connection refused

**symptoms**: `ssh: connect to host localhost port 2222: Connection refused`

**causes**:
- russh server not running in redox
- port forwarding not set up correctly
- qemu networking issue

**solutions**:
1. check russh is running: `ps aux | grep russhd` (in redox)
2. verify port forwarding: check qemu command has `hostfwd=tcp::2222-:22`
3. restart qemu with correct port forwarding

---

### permission denied (publickey)

**symptoms**: `Permission denied (publickey)`

**causes**:
- authorized_keys not in redox
- wrong public key
- wrong permissions on authorized_keys

**solutions**:
1. verify key is in config: check `config/x86_64/minimal.toml`
2. rebuild redox: `make all CONFIG_NAME=minimal ...`
3. check permissions in redox: `ls -la ~/.ssh/authorized_keys` (should be 600)

---

### host key verification failed

**symptoms**: `Warning: Permanently added 'localhost' (ED25519) to the list of known hosts`

**this is normal!** first connection always shows this.

**to avoid**: add to ssh config:
```
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
```

---

## russh testing

### test basic ssh connection

```bash
# From host
ssh -p 2222 -i ~/.ssh/id_ed25519_redox user@localhost 'echo "SSH works!"'
```

### test file transfer

```bash
# Copy file TO redox
scp -P 2222 -i ~/.ssh/id_ed25519_redox file.txt user@localhost:~

# Copy file FROM redox
scp -P 2222 -i ~/.ssh/id_ed25519_redox user@localhost:~/file.txt ./
```

### test command execution

```bash
# Run command in redox from host
ssh -p 2222 -i ~/.ssh/id_ed25519_redox user@localhost 'uname -a'
```

---

## contributing to redox

### add russh to redox cookbook

**if russh isn't in official cookbook yet:**

1. fork redox cookbook on gitlab
2. add russh recipe
3. submit merge request
4. help entire redox community!

**this is angel blue computing** - contributing harmoniously to help everyone.

---

## scripts provided

### redox-add-ssh-keys.sh
- adds ed25519 public key to redox config
- backs up original config
- kid-friendly messages

### redox-install-russh.sh
- creates russh recipe
- adds to config
- generates host keys
- complete setup

### redox-ssh-setup-complete.sh
- runs all steps automatically
- checks prerequisites
- provides instructions

---

## next steps

### immediate
- ✅ generate ed25519 keys
- ✅ add to redox config
- ⬜ rebuild redox with ssh
- ⬜ test connection

### short term
- test russh functionality
- optimize russh config
- add to redox cookbook (if not present)
- document for others

### long term
- contribute russh improvements
- help redox community
- build grain network on redox
- run steel lisp on redox!

---

## resources

### russh library
- github: https://github.com/warp-tech/russh
- pure rust ssh implementation
- supports ed25519 keys
- perfect for redox!

### redox cookbook
- gitlab: https://gitlab.redox-os.org/redox-os/cookbook
- recipes for redox packages
- submit russh recipe here!

### ssh ed25519
- best practice for modern systems
- small, fast, secure
- perfect for redox

---

**remember**: ed25519 keys are the way to go! 🌊✨

**airbender mode**: ssh keys flow into redox, enabling development access!

