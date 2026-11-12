# RTL Lab

A collection of RTL designs and their testbenches.

| Project | Description |
| --- | --- |
| [UART](uart/) | UART transmitter study |

Each block gets a top-level directory, such as `uart/`, `spi/`, or `fifo/`.
Put synthesizable sources in `rtl/` and testbenches in `tb/`. Add `sim/` for
simulation scripts and `constraints/` for board-specific pin and timing
constraints when the project needs them.

Each project README records its interface, how to run its tests, and what has
been verified. Add a project to the table when its first source is ready.
