# UART

A VHDL UART transmitter and receiver with an 8-bit, LSB-first data field and no parity.

- [rtl/](rtl/) contains the transmitter and receiver cores.
- [tb/](tb/) contains their waveform testbenches.
- [examples/](examples/) contains the switch/button wrapper and its debounce block.
  The wrapper needs pin and clock constraints for a board build.

## Interface

Pulse `tx_start_i` for one rising clock edge while the transmitter is idle to
latch `din_i`. `tx_o` idles high and `tx_done_tick_o` pulses for one cycle
after the stop bit. The defaults are 100 MHz and 115,200 baud. The divider uses
integer truncation. This revision emits one stop bit regardless of `c_stopbit`.

The receiver (`reciever`) samples `rx_i` and shifts each data bit into the
register exposed on `dout_o`. Read the assembled byte when `rx_done_tick_o`
pulses during the stop bit. The defaults are 100 MHz and 115,200 baud.

## Simulation

Run from the repository root with Vivado XSim on PATH, or set `VIVADO_BIN` to
the Vivado bin directory.

```powershell
powershell -File uart/sim/run.ps1
```

The testbench drives two bytes and uses `SIM DONE` at severity failure as its
end marker. Inspect `tx_o` in XSim to verify the waveform. The testbench does
not assert frame contents or timing.

For the receiver, add `rtl/reciever.vhd` and `tb/tb_reciever.vhd` to a Vivado
project and set `tb_reciever` as the simulation top. Run for 41 µs and inspect
`dout_o` and `rx_done_tick_o`. The testbench sends `0x43` and `0xA5` at
1 Mbaud and ends with the same `SIM DONE` marker.
