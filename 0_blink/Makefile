BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: blink.fs

# Synthesis
blink.json: blink.v
	yosys -p "read_verilog blink.v; synth_gowin -top blink -json blink.json"

# Place and Route
blink_pnr.json: blink.json
	nextpnr-gowin --json blink.json --freq 27 --write blink_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
blink.fs: blink_pnr.json
	gowin_pack -d ${FAMILY} -o blink.fs blink_pnr.json

# Program Board
load: blink.fs
	openFPGALoader -b ${BOARD} blink.fs -f

.PHONY: load
.INTERMEDIATE: blink_pnr.json blink.json