# building redox from source with ssh and our code

**purpose**: rebuild redox os with our monolithic-compat code
built in, ssh access configured, and authorized_keys set up
for cursor "run everything" mode.

**why this guide?** we need redox rebuilt with our steel
modules and ssh access so we can develop and benchmark.

---

## prerequisites

### 1. clone redox repository
```bash
# set redox directory (default: ~/gitlab/redox-os/redox)
export REDOX_DIR="${REDOX_DIR:-$HOME/gitlab/redox-os/redox}"

# clone redox
git clone https://gitlab.redox-os.org/redox-os/redox.git \
  "$REDOX_DIR"

# initialize submodules
cd "$REDOX_DIR"
git submodule update --init --recursive
```

### 2. install build dependencies
```bash
# ubuntu/debian dependencies
sudo apt update
sudo apt install -y \
  curl \
  file \
  git \
  libssl-dev \
  pkg-config \
  python3 \
  xz-utils \
  zlib1g-dev

# install rust toolchain
curl --proto '=https' --tlsv1.2 -sSf \
  https://sh.rustup.rs | sh

# install redox toolchain
curl -sf \
  https://raw.githubusercontent.com/redox-os/redox/master/install.sh | \
  bash -s -- --prefix "$HOME/.redox"
```

---

## step 1: add our monolithic-compat code

### copy our steel modules to redox
```bash
# from grainkae3g repo root
cd /home/xy/kae3g/grainkae3g

# create redox package directory
mkdir -p "$REDOX_DIR/cookbook/recipes/grain-monolithic-compat"

# copy our modules
cp -r scripts/grain-monolithic-compat/* \
  "$REDOX_DIR/cookbook/recipes/grain-monolithic-compat/"
```

### create redox recipe
```bash
cat > "$REDOX_DIR/cookbook/recipes/grain-monolithic-compat/recipe.toml" << 'EOF'
# grain-monolithic-compat - monolithic-like compatibility layer

[package]
name = "grain-monolithic-compat"
version = "0.1.0"
license = "MIT OR Apache-2.0"

[build]
dependencies = ["steel"]

[build.script]
build = '''
# install steel modules to /usr/lib/steel/grain-monolithic-compat/
mkdir -p /install/usr/lib/steel/grain-monolithic-compat/utils
cp -r grain-monolithic-compat/*.scm /install/usr/lib/steel/
cp -r grain-monolithic-compat/utils/*.scm \
  /install/usr/lib/steel/grain-monolithic-compat/utils/
cp -r grain-monolithic-compat/benchmarks \
  /install/usr/lib/steel/grain-monolithic-compat/
'''

[install]
files = [
  { path = "/usr/lib/steel/grain-monolithic-compat", 
    source = "/install/usr/lib/steel/grain-monolithic-compat" },
]
EOF
```

---

## step 2: configure ssh access

### generate ed25519 ssh key (if needed)
```bash
# check if key exists
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ]; then
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" \
    -C "cursor-redox-$(hostname)" -N ""
fi

# display public key
cat "$HOME/.ssh/id_ed25519.pub"
```

### add ssh key to redox config
```bash
# use our script
cd /home/xy/kae3g/grainkae3g
export REDOX_DIR="$REDOX_DIR"
export SSH_KEY_FILE="$HOME/.ssh/id_ed25519.pub"
export CONFIG_NAME="minimal"

./scripts/redox-add-ssh-keys.sh
```

### add russh ssh server (if not already)
```bash
# use our script
./scripts/redox-install-russh.sh
```

---

## step 3: create sudo user

### add user configuration to redox config
```bash
CONFIG_FILE="$REDOX_DIR/config/x86_64/minimal.toml"

# add user with sudo privileges
cat >> "$CONFIG_FILE" << 'EOF'

# user configuration for cursor access
[[users]]
name = "user"
password = ""  # empty = no password required
groups = ["wheel"]  # wheel group = sudo access

# ensure user home directory exists
[[files]]
path = "/home/user/.ssh"
mode = 0o700

[[files]]
path = "/home/user/.ssh/authorized_keys"
data = """
# ssh key will be added by redox-add-ssh-keys.sh
"""
mode = 0o600
EOF
```

---

## step 4: rebuild redox

### build with our package included
```bash
cd "$REDOX_DIR"

# add grain-monolithic-compat to config
CONFIG_FILE="config/x86_64/minimal.toml"

# add to packages section
if ! grep -q 'grain-monolithic-compat' "$CONFIG_FILE"; then
  if grep -q '^\[packages\]' "$CONFIG_FILE"; then
    sed -i '/^\[packages\]/a grain-monolithic-compat = {}' \
      "$CONFIG_FILE"
  else
    echo "" >> "$CONFIG_FILE"
    echo "[packages]" >> "$CONFIG_FILE"
    echo "grain-monolithic-compat = {}" >> "$CONFIG_FILE"
  fi
fi

# build redox (this takes a while!)
make all CONFIG_NAME=minimal \
  PODMAN_ENV="--env CI=1 --env PATH=/home/poduser/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --env PODMAN_BUILD=0"
```

---

## step 5: boot redox with ssh forwarding

### start qemu with port forwarding
```bash
cd "$REDOX_DIR"

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 2048 \
  -smp 4 \
  -drive file=build/x86_64/minimal/harddrive.img,format=raw \
  -device e1000,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -display sdl
```

### connect via ssh
```bash
# wait for redox to boot, then connect
ssh -p 2222 -i ~/.ssh/id_ed25519 user@localhost

# if connection fails, check:
# 1. russh server is running in redox
# 2. authorized_keys file has your public key
# 3. port forwarding is correct (2222 -> 22)
```

---

## step 6: verify our code is installed

### check steel modules
```bash
# in redox ssh session
ls -la /usr/lib/steel/grain-monolithic-compat/

# should show:
# - linux-compat.scm
# - syscall-layer.scm
# - utils/
# - benchmarks/
```

### test monolithic-compat
```bash
# in redox ssh session
steel -e '(require "grain-monolithic-compat/linux-compat.scm") 
         (displayln "monolithic-compat loaded!")'
```

### run benchmarks
```bash
# in redox ssh session
steel /usr/lib/steel/grain-monolithic-compat/benchmarks/main.scm 100
```

---

## cursor "run everything" mode setup

### configure ssh config for cursor
```bash
# add to ~/.ssh/config on ubuntu host
cat >> ~/.ssh/config << 'EOF'

Host redox-vm
  HostName localhost
  Port 2222
  User user
  IdentityFile ~/.ssh/id_ed25519
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF
```

### test cursor connection
```bash
# from cursor terminal
ssh redox-vm "steel --version"

# should connect and run command
```

---

## troubleshooting

### build fails
- check rust toolchain: `rustc --version`
- check redox toolchain: `x86_64-unknown-redox-gcc --version`
- check disk space: `df -h`
- try clean build: `make clean && make all`

### ssh connection fails
- verify port forwarding: `netstat -tlnp | grep 2222`
- check russh is running in redox
- verify authorized_keys has your public key
- check ssh key permissions: `chmod 600 ~/.ssh/id_ed25519`

### code not found in redox
- verify recipe.toml syntax
- check package is in config.toml packages section
- rebuild redox after adding package
- check files in redox: `ls -la /usr/lib/steel/`

---

## references

- **redox os**: https://gitlab.redox-os.org/redox-os/redox
- **redox cookbook**: https://gitlab.redox-os.org/redox-os/cookbook
- **our scripts**: `scripts/redox-add-ssh-keys.sh`, 
  `scripts/redox-install-russh.sh`
- **matrix chat**: redox os/general room (insights from bjorn3)

---

**now == next + 1 🌾⚒️**

