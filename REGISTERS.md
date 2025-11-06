# 🧠 x86-64 Registers — Quick Reference Guide

## 1️⃣ Basic Classification

| **Category** | **Registers** | **Typical Use** |
|---------------|---------------|------------------|
| General-purpose (64-bit) | RAX, RBX, RCX, RDX, RSI, RDI, RBP, RSP, R8–R15 | Generic operations, arithmetic, pointers |
| Index & pointers | RSI, RDI | Source and destination addresses |
| Counter | RCX | Loop counters |
| Accumulators | RAX, RDX | Arithmetic operations and function return values |
| Stack | RSP, RBP | Stack frame management |

---

## 2️⃣ Size Hierarchy

| 64-bit | 32-bit | 16-bit | 8-bit |
|:------:|:------:|:------:|:------:|
| RAX | EAX | AX | AL / AH |
| RBX | EBX | BX | BL / BH |
| RCX | ECX | CX | CL / CH |
| RDX | EDX | DX | DL / DH |

---

## 3️⃣ Practical Usage Guidelines

| **Purpose** | **Common Register** | **Reason** |
|--------------|---------------------|-------------|
| Return value | RAX | System V ABI convention |
| 1st argument | RDI | System V ABI convention |
| 2nd argument | RSI | System V ABI convention |
| 3rd–6th arguments | RDX, RCX, R8, R9 | System V ABI convention |
| Loop / counter | RCX | Historical use |
| Memory iteration | RSI (src), RDI (dest) | Used by string instructions |
| Temporaries | RAX, RDX, R10–R11 | Volatile, can be freely used |
| Preserved variables | RBX, R12–R15 | Callee-saved (preserved across calls) |

---

## ⚙️ Quick Mental Rules

- **Small data → small registers**  
- **Pointers and counters → 64-bit registers**  
- **When unsure, use 64-bit (`q`) registers and clear temporary ones**

---

📘 *Markdown version of “registri_x86_64_spiegazione.pdf” for quick lookup in Assembly projects.*
