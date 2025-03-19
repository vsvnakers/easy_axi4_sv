# 变量定义
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

SRC = ../src/axi4_slave.sv ../src/axi4_tb.sv
OUTPUT = axi4_tb
VCD_FILE = axi4_tb.vcd

all: run

# 使用 Icarus Verilog (iverilog) 进行仿真
compile:
	$(IVERILOG) -g2012 -o $(OUTPUT) $(SRC)

simulate: compile
	$(VVP) $(OUTPUT)

run: simulate
	@echo "Simulation completed. Run 'make view' to see waveforms."

# 打开 GTKWave 观察波形
view:
	$(GTKWAVE) $(VCD_FILE) &

clean:
	rm -f $(OUTPUT) $(VCD_FILE)
