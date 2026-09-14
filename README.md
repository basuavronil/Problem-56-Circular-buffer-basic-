# 8x8 Synchronous Circular Buffer (FIFO)

A Verilog implementation of an 8-entry, 8-bit wide Circular Buffer (FIFO) featuring explicit wrap-around tracking via 4-bit pointers.

---

## 📌 Architecture Highlights
* **Depth & Width:** 8 depth entries, 8 bits wide.
* **Pointer Logic:** Uses 4-bit write (`wr_ptr`) and read (`rd_ptr`) pointers:
  * Bits `[2:0]` select the memory array address.
  * Bit `[3]` acts as the wrap-around indicator.
* **Status Flags:**
  * **Empty:** Asserted when `rd_ptr == wr_ptr`.
  * **Full:** Asserted when address bits match (`rd_ptr[2:0] == wr_ptr[2:0]`) but wrap bits differ (`rd_ptr[3] != wr_ptr[3]`).

---

## 📁 Repository Structure

```text
├── circular_buffer.v       # Design Module (DUT)
├── circular_buffer_tb.v    # Testbench ($dumpvars +$monitor)
└── README.md               # Documentation
```
## Output
### Waveform 
<img width="937" height="197" alt="image" src="https://github.com/user-attachments/assets/8a5ffb4f-dedf-4b2a-9e35-9c1b32fccc83" />

### Simulation Terminal
<img width="398" height="282" alt="image" src="https://github.com/user-attachments/assets/a838d65b-7159-4296-aa5a-ecd16750c56e" />
