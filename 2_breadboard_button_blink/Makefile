BOARD=tangnano9k
FAMILY=GW1N-9C
DEVICE=GW1NR-LV9QN88PC6/I5

all: breadboard_button_blink.fs

# Synthesis
breadboard_button_blink.json: breadboard_button_blink.v
	yosys -p "read_verilog breadboard_button_blink.v; synth_gowin -top breadboard_button_blink -json breadboard_button_blink.json"

# Place and Route
breadboard_button_blink_pnr.json: breadboard_button_blink.json
	nextpnr-gowin --json breadboard_button_blink.json --freq 27 --write breadboard_button_blink_pnr.json --device ${DEVICE} --family ${FAMILY} --cst ${BOARD}.cst

# Generate Bitstream
breadboard_button_blink.fs: breadboard_button_blink_pnr.json
	gowin_pack -d ${FAMILY} -o breadboard_button_blink.fs breadboard_button_blink_pnr.json

# Program Board
load: breadboard_button_blink.fs
	openFPGALoader -b ${BOARD} breadboard_button_blink.fs -f

.PHONY: load
.INTERMEDIATE: breadboard_button_blink_pnr.json breadboard_button_blink.json