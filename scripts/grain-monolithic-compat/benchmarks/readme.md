# microkernel vs monolithic benchmark suite

**purpose**: measure performance differences between microkernel
(redox) and monolithic (linux) architectures

**why benchmarks?** ipc overhead is the main cost difference.
we need data to understand trade-offs.

**⚠️  important limitation**: these benchmarks only show real
microkernel vs monolithic differences when comparing results
from:
- **redox os** (microkernel) - run benchmarks here
- **linux** (monolithic) - compare results from here

**running on ubuntu/linux**: when you run these benchmarks on
ubuntu 24.04 lts (or any linux), both "microkernel" and
"monolithic" modes run on the same monolithic kernel. you're
measuring abstraction overhead, not actual ipc differences.

**to get real results**: 
1. run benchmarks on redox os (microkernel)
2. run benchmarks on linux (monolithic)  
3. compare the results

**insight from redox community**: syscall count doesn't directly
affect battery drain if performance is similar. power management
(sleep states, timer coalescing) matters more.

---

## structure

the benchmark suite is decomplected into separate concerns:

- **metrics.scm**: timing and measurement utilities
- **runner.scm**: benchmark execution framework
- **specs.scm**: type validation for benchmark data
- **macros.scm**: abstraction macros for defining benchmarks
- **utils.scm**: formatting and utility functions
- **syscall-bench.scm**: system call overhead tests
- **file-io-bench.scm**: file i/o performance tests
- **process-bench.scm**: process spawning overhead tests
- **main.scm**: entry point and results display

---

## usage

**on ubuntu/linux** (for testing structure only):
```bash
steel scripts/grain-monolithic-compat/benchmarks/main.scm
```
note: results show abstraction overhead, not real ipc differences.

**on redox os** (for real microkernel results):
```bash
steel scripts/grain-monolithic-compat/benchmarks/main.scm
```

**on linux** (for real monolithic results):
```bash
steel scripts/grain-monolithic-compat/benchmarks/main.scm
```

**compare results**: run on both systems and compare to see
real microkernel vs monolithic performance differences.

**custom iteration count**:
```bash
steel scripts/grain-monolithic-compat/benchmarks/main.scm 5000
```

---

## benchmarks

### syscall benchmarks
- **null-syscall**: pure ipc overhead (no-op syscall)
- **open-syscall**: file open operation overhead
- **read-syscall-1k**: read 1kb data transfer overhead
- **read-syscall-64k**: read 64kb data transfer overhead

### file i/o benchmarks
- **seq-read-1mb**: sequential read 1mb file
- **seq-read-10mb**: sequential read 10mb file
- **small-write**: small file write operation

### process benchmarks
- **spawn**: process creation overhead
- **fork**: process duplication overhead

---

## results format

each benchmark shows:
- average time (microseconds)
- minimum time
- maximum time
- overhead percentage (microkernel vs monolithic)

---

**now == next + 1 🌾⚒️**

