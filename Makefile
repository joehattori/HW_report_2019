collatz:
	ghdl -a --ieee=synopsys types.vhd
	ghdl -a --ieee=synopsys sorter.vhd
	ghdl -a --ieee=synopsys mountain.vhd
	ghdl -a --ieee=synopsys collatz.vhd
	ghdl -a --ieee=synopsys collatz_tb.vhd
	ghdl -e --ieee=synopsys CollatzTb
	ghdl -r --ieee=synopsys CollatzTb --vcd=collatz.vcd
