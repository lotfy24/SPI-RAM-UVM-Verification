# SPI-RAM-UVM-Verification

A complete UVM verification project for an SPI Slave connected to a RAM through a top-level wrapper.

## Project Overview

This project implements and verifies an SPI Slave that communicates with a RAM. The verification environment is developed using **SystemVerilog** and **UVM**, ensuring functional correctness through constrained-random testing, assertions, and coverage collection.

## Project Structure

```
SPI-RAM-UVM-Verification/
│
├── SPI_Slave/
│   ├── RTL/
│   ├── UVM/
│   └── ...
│
├── RAM/
│   ├── RTL/
│   ├── UVM/
│   └── ...
│
├── Wrapper/
│   ├── RTL/
│   ├── UVM/
│   └── ...
│
└── README.md
```

## Features

### SPI Slave
- SPI Mode 0 communication
- Serial data reception and transmission
- Command decoding
- Interface with RAM

### RAM
- Synchronous memory
- Read and write operations
- Parameterized memory depth and width

### Wrapper
- Connects the SPI Slave with the RAM
- Top-level integration for simulation and verification

## Verification Methodology

The verification environment is built using **Universal Verification Methodology (UVM)**.

### UVM Components
- Sequence Item
- Sequences
- Sequencer
- Driver
- Monitor
- Agent
- Environment
- Scoreboard
- Subscriber/Coverage
- Test

## Verification Features

- Constrained-random stimulus
- Functional coverage
- Assertions (SVA)
- Scoreboard-based checking
- Multiple test scenarios
- Self-checking testbench

## Tools Used

- SystemVerilog
- UVM
- QuestaSim / ModelSim
- Vivado (RTL synthesis)

## Simulation Flow

1. Compile RTL and UVM files.
2. Run the desired UVM test.
3. Observe simulation logs.
4. Check assertions.
5. Analyze functional coverage.

## Repository Contents

| Folder | Description |
|---------|-------------|
| `SPI_Slave` | SPI Slave RTL and UVM verification |
| `RAM` | RAM RTL and UVM verification |
| `Wrapper` | Top-level wrapper and verification |

## Future Improvements

- Add regression scripts
- Increase functional coverage
- Add corner-case test scenarios
- Integrate with CI/CD
- Generate automated coverage reports


