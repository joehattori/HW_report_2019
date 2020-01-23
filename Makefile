collatz:
	ghdl -a --ieee=synopsys collatz.vhd
	ghdl -a --ieee=synopsys collatz_tb.vhd
	ghdl -e --ieee=synopsys CollatzTb
	ghdl -r --ieee=synopsys CollatzTb --vcd=collatz.vcd
