# Assembly Playground 🧩

A collection of exercises and small programs written in **x86-64 Assembly (GAS syntax)**.
Each file explores a different low-level concept: registers, loops, memory access, string operations, binary arithmetic, and system calls.

---

## ⚙️ Repository Structure

```
assembly-playground/
│
├── exercise.s           # Exercise
├── test.c               # Optional C program to test Assembly modules
└── README.md
```

---

## 🚀 Running an Exercise

Each Assembly file can be compiled and executed directly from the terminal:

```bash
as filename.s -o filename.o
ld filename.o -o filename
./filename
```

---

## 🧰 Using the I/O Utility Library

Some exercises rely on basic input/output functions (like input, output, outline, etc.) defined in a shared I/O utility library.
To use it, simply compile your Assembly file together with io_utils.s:

```bash
gcc filename.s ../io_utils.s -o demo
./demo
```

---

## 🧪 Testing with C

You can test an Assembly function through a C program:

```bash
gcc filename.s testname.c -o test
./test
```

---

## 💡 Tips

* All programs are written for **x86-64 architecture** (modern Intel/AMD CPUs).
* The syntax used is **GAS (GNU Assembler)**, the default on Linux systems.
* Each `.s` file is **standalone** and can be executed independently.
* Great for practicing:

  * register handling (`rax`, `rbx`, `rcx`, `rdx`, …)
  * loops and comparisons (`cmp`, `test`, `jmp`)
  * memory access (`mov`, `lea`)
  * calling conventions and stack usage

---

## 📚 Goal

A personal lab to explore **how the CPU really works**, one exercise at a time.
Perfect for learning, experimenting, and showcasing Assembly skills.
