# GateMate FPGA Makefile - (c) Pigeon Nation 2026

TOP      ?= top
CCF      ?= fpga.ccf
DEVICE   ?= CCGM1A1
SEED     ?= 1
NETLIST  := $(TOP).json
NETLIST_V := $(TOP)_netlist.v
ALL_V     := $(wildcard *.v)
PNR_OUT  := $(TOP).txt
BIT      := $(TOP).bit
SRCS      := $(filter-out $(NETLIST_V), $(ALL_V))

.PHONY: all synth pnr pack flash clean

all: $(BIT)

$(NETLIST) $(NETLIST_V): $(SRCS)
	yosys -p "read_verilog $(SRCS); \
	          synth_gatemate -top $(TOP) -luttree -nomx8; \
	          write_json $(NETLIST); \
	          write_verilog $(NETLIST_V)"

synth: $(NETLIST)

$(PNR_OUT): $(NETLIST) $(CCF)
	nextpnr-himbaechel \
		--device=$(DEVICE) \
		--json $(NETLIST) \
		-o ccf=$(CCF) \
		-o out=$(PNR_OUT) \
		--router router2 \
		--seed $(SEED)

pnr: $(PNR_OUT)

$(BIT): $(PNR_OUT)
	gmpack $(PNR_OUT) $(BIT)

pack: $(BIT)

permflash: $(BIT)
	openFPGALoader -b gatemate_evb_jtag --index-chain 0 --cable dirtyJtag --write-flash $(BIT)

flash: $(BIT)
	openFPGALoader --index-chain 0 --cable dirtyJtag $(BIT)

clean:
	rm -f $(NETLIST) $(NETLIST_V) $(PNR_OUT) $(BIT)
