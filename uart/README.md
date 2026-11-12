# UART

A VHDL UART transmitter with an 8-bit, LSB-first data field and no parity.

- [rtl/](rtl/) contains the transmitter core.
- [tb/](tb/) contains the original waveform testbench.
- [examples/](examples/) contains the switch/button wrapper and its debounce block.
  The wrapper needs pin and clock constraints for a board build.

## Interface

Pulse `tx_start_i` for one rising clock edge while the transmitter is idle to
latch `din_i`. `tx_o` idles high and `tx_done_tick_o` pulses for one cycle
after the stop bit. The defaults are 100 MHz and 115,200 baud. The divider uses
integer truncation. This revision emits one stop bit regardless of `c_stopbit`.

## Simulation

Run from the repository root with Vivado XSim on PATH, or set `VIVADO_BIN` to
the Vivado bin directory.

```powershell
powershell -File uart/sim/run.ps1
```

The testbench drives two bytes and uses `SIM DONE` at severity failure as its
end marker. Inspect `tx_o` in XSim to verify the waveform. The testbench does
not assert frame contents or timing.
