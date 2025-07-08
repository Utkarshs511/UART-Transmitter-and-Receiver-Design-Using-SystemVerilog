# UART Transmitter and Receiver Design Using SystemVerilog

This project implements a **Universal Asynchronous Receiver/Transmitter (UART)** communication system using **SystemVerilog**. The design features modular development of the Transmitter, Receiver, and Baud Rate Generator with FSM-based control and timing synchronization. It is simulated using testbenches with waveform analysis to verify correctness.

---

##  Features

-  Full UART protocol implementation (Start, Data, Parity, Stop)
-  Modular design: Transmitter, Receiver, and Baud Rate Generator
-  Operates at **different baud rate** from a **100 MHz system clock**
-  Parallel operation of TX and RX modules
-  **Busy flags** to indicate active transmission or reception
-  **Parity error detection** in the receiver
-  **Prevents repeated sending** when enable is held high
-  Supports **6 different baud rate selections**
-  Error handling for incorrect baud rate configuration

---

##  Module Overview

### `transmitter.sv`
- Takes 8-bit parallel data input
- Adds start and stop bits for framing
- Controlled by a finite state machine (FSM)
- Uses baud tick from generator for bit timing
- Prevents repeat transmission on constant enable

### `receiver.sv`
- Monitors RX line for start bit
- Samples bits at mid-bit interval
- Reconstructs received 8-bit data
- FSM controls state and bit alignment
- Parity checking included

### `baud_rate_generator.sv`
- Divides 100 MHz system clock
- Generates tick signals for UART timing
- Supports 6 selectable baud rates
- Indicates error on incorrect configuration

### `testbench.sv`
- Simulates UART TX-RX communication
- Provides input stimulus and checks outputs
- Uses `$display` and waveform tools

---

##  Simulation Results

### Parallel TX & RX Operation
- Both modules function independently
- Busy signal indicates ongoing TX or RX
- No data loss during simultaneous activity

### Baud Rate Handling
- Accurate tick generation for UART
- Detects configuration errors during selection

### Transmitter Waveform
- Serial data framing (start, data, stop)
- Prevents repeated send on held-high enable

###  Receiver Waveform
- Proper framing and byte capture
- Detects parity errors on mismatch

---

##  Learning Outcomes

- FSM design and implementation
- Bit-level serial communication protocol
- Clock division and synchronization
- Testbench-driven validation
- Hardware modeling in HDL

---
