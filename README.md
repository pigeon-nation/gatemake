# gatemake
Gatemate FPGA Makefile/Toolchain

> note:
> The uploading part of this toolchain is specifically designed for use with the GateMateA1-EVB board by Olimex.

Name your top verilog file `top.v`, and constraints file `fpga.ccf`.
No other files have to be present for this to work, but both files should be in the same directory
as this Makefile, with make being run in that directory as well.

## Usage

To build just a bitstream, just use `make`.

To upload to the board's ram, use \
`make flash`

To upload to the onboard bitstream storage, if it is present, use \
`make nvflash`
