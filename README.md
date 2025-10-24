# 🚀 UVM-Based Verification of SPI Wrapper with RAM

This project presents a complete **UVM verification environment** for an **SPI Wrapper System**, which connects an **SPI Slave module** and a **Single-Port RAM**.  
The testbench follows **Universal Verification Methodology (UVM)** standards and ensures correctness through **golden models**, **assertions**, **functional coverage**, and **scoreboards**.  
The verification environment combines **active and passive agents** to achieve full modularity, reusability, and coverage-driven verification.

---

## 🧩 Key Features

- **UVM 1.2-compliant** SystemVerilog testbench  
- **Wrapper Environment (Active Agent)** driving DUT stimulus  
- **SPI & RAM Environments (Passive Agents)** for monitoring protocol behavior  
- **Golden Reference Models** for functional correctness checking  
- **SystemVerilog Assertions (SVA)** for protocol and timing validation  
- **Functional and Code Coverage Reports** for completeness tracking  
- **Reusable and Scalable UVM Architecture**

---

## 📁 Project Structure

| File/Folder          | Description |
|----------------------|-------------|
| `rtl/`               | Contains DUT (Wrapper, SPI Slave, and RAM modules) |
| `tb/`                | Top-level testbench and virtual interfaces |
| `env/`               | UVM environments, agents, monitors, scoreboards, and coverage collectors |
| `tests/`             | Contains different test scenarios (smoke, read, write, read/write) |
| `dofile/`            | ModelSim/Questa simulation scripts |
| `reports/`           | Coverage, assertion, and waveform reports |
| `docs/`              | Verification plan and design documentation |

---

## 🧠 UVM Architecture Overview

### 🔸 Wrapper Environment (Active Agent)
- Generates stimulus and drives transactions to the DUT  
- Components:
  - `Wrapper_driver` — converts sequence items to DUT signals  
  - `Wrapper_monitor` — captures and reconstructs transactions  
  - `Wrapper_scoreboard` — compares DUT vs Golden Wrapper outputs  
  - `Wrapper_coverage` — collects functional coverage  
  - `Wrapper_sequencer` — manages transaction flow between driver and sequences  

### 🔹 SPI & RAM Environments (Passive Agents)
- **SPI_env** and **RAM_env** monitor interface activity only  
- Each includes:
  - `monitor` — captures data from the interface  
  - `scoreboard` — validates results with golden models  
  - `coverage` — ensures full transaction coverage  

> Passive agents ensure correctness of data exchange between the Wrapper and its submodules without altering DUT behavior.

---

## 🔄 Transaction Flow

| Phase | Description |
|--------|-------------|
| **Build Phase** | Constructs all UVM components and virtual interfaces |
| **Connect Phase** | Connects analysis ports between monitors, scoreboards, and coverage |
| **Run Phase** | Starts sequences, drives DUT, captures responses |
| **Check Phase** | Scoreboards compare DUT vs golden model outputs |
| **Report Phase** | Generates coverage, assertion, and waveform reports |

---

## 🧮 Sequences Implemented

- **Read_Sequence** — performs read transactions from memory  
- **Write_Sequence** — performs write transactions to memory  
- **Read_Write_Sequence** — verifies combined read and write operations  

Each sequence creates a `Wrapper_Seq_Item` with parameters:
- Address  
- Data  
- Operation type  

---

## ✅ Assertions & Protocol Checks

| Assertion | Description |
|------------|-------------|
| **Reset Low Outputs** | Ensures all outputs are inactive during reset |
| **State Transitions** | Checks IDLE → CHK_CMD → WRITE / READ transitions |
| **Timing Validation** | Ensures `rx_valid` is asserted 10 cycles after command |
| **Signal Stability** | Confirms `MISO` is stable when not in read state |
| **Handshake** | Validates synchronization between `tx_valid` and `rx_valid` |

Example:
```systemverilog
property reset_low_outputs;
  @(posedge clk)
  (!rst_n) |=> (MISO == 0 && rx_valid == 0 && rx_data == 0);
endproperty
```
---
# 🚀 UVM-Based Verification of SPI Wrapper with RAM

This project presents a complete **UVM verification environment** for an **SPI Wrapper System**, which connects an **SPI Slave module** and a **Single-Port RAM**.  
The testbench follows **Universal Verification Methodology (UVM)** standards and ensures correctness through **golden models**, **assertions**, **functional coverage**, and **scoreboards**.  
The verification environment combines **active and passive agents** to achieve full modularity, reusability, and coverage-driven verification.

---

## 🧩 Key Features

- **UVM 1.2-compliant** SystemVerilog testbench  
- **Wrapper Environment (Active Agent)** driving DUT stimulus  
- **SPI & RAM Environments (Passive Agents)** for monitoring protocol behavior  
- **Golden Reference Models** for functional correctness checking  
- **SystemVerilog Assertions (SVA)** for protocol and timing validation  
- **Functional and Code Coverage Reports** for completeness tracking  
- **Reusable and Scalable UVM Architecture**

---

## 📁 Project Structure

| File/Folder          | Description |
|----------------------|-------------|
| `rtl/`               | Contains DUT (Wrapper, SPI Slave, and RAM modules) |
| `tb/`                | Top-level testbench and virtual interfaces |
| `env/`               | UVM environments, agents, monitors, scoreboards, and coverage collectors |
| `tests/`             | Contains different test scenarios (smoke, read, write, read/write) |
| `dofile/`            | ModelSim/Questa simulation scripts |
| `reports/`           | Coverage, assertion, and waveform reports |
| `docs/`              | Verification plan and design documentation |

---

## 🧠 UVM Architecture Overview

### 🔸 Wrapper Environment (Active Agent)
- Generates stimulus and drives transactions to the DUT  
- Components:
  - `Wrapper_driver` — converts sequence items to DUT signals  
  - `Wrapper_monitor` — captures and reconstructs transactions  
  - `Wrapper_scoreboard` — compares DUT vs Golden Wrapper outputs  
  - `Wrapper_coverage` — collects functional coverage  
  - `Wrapper_sequencer` — manages transaction flow between driver and sequences  

### 🔹 SPI & RAM Environments (Passive Agents)
- **SPI_env** and **RAM_env** monitor interface activity only  
- Each includes:
  - `monitor` — captures data from the interface  
  - `scoreboard` — validates results with golden models  
  - `coverage` — ensures full transaction coverage  

> Passive agents ensure correctness of data exchange between the Wrapper and its submodules without altering DUT behavior.

---

## 🔄 Transaction Flow

| Phase | Description |
|--------|-------------|
| **Build Phase** | Constructs all UVM components and virtual interfaces |
| **Connect Phase** | Connects analysis ports between monitors, scoreboards, and coverage |
| **Run Phase** | Starts sequences, drives DUT, captures responses |
| **Check Phase** | Scoreboards compare DUT vs golden model outputs |
| **Report Phase** | Generates coverage, assertion, and waveform reports |

---

## 🧮 Sequences Implemented

- **Read_Sequence** — performs read transactions from memory  
- **Write_Sequence** — performs write transactions to memory  
- **Read_Write_Sequence** — verifies combined read and write operations  

Each sequence creates a `Wrapper_Seq_Item` with parameters:
- Address  
- Data  
- Operation type  

---

## ✅ Assertions & Protocol Checks

| Assertion | Description |
|------------|-------------|
| **Reset Low Outputs** | Ensures all outputs are inactive during reset |
| **State Transitions** | Checks IDLE → CHK_CMD → WRITE / READ transitions |
| **Timing Validation** | Ensures `rx_valid` is asserted 10 cycles after command |
| **Signal Stability** | Confirms `MISO` is stable when not in read state |
| **Handshake** | Validates synchronization between `tx_valid` and `rx_valid` |

---
## 📊 Coverage and Reports

| Report Type | Description |
|--------------|-------------|
| **Functional Coverage** | Tracks command types, addresses, and operation sequences |
| **Assertion Coverage** | Verifies activation of all SVA checks |
| **Code Coverage** | Confirms all logic branches and FSM states are tested |
| **Waveforms** | Show read/write sequences and SPI transactions |

---

## 🧱 Verification Summary

- ✅ Data correctness verified using Golden Models  
- ⚙️ Protocol adherence confirmed through assertions  
- ⏱ Timing validated for each transaction phase  
- 📈 Coverage closure achieved for SPI and Wrapper modules  
- 🔄 Passive agents used for non-intrusive protocol observation  

---

## 🛠 Tools Used

- **Simulation**: ModelSim / QuestaSim  
- **Language**: SystemVerilog + UVM 1.2  
- **Verification Methodology**: UVM  
- **Target DUT**: SPI Wrapper with Single-Port RAM  

