transcript on

if { [file exists "work"] } {
    vdel -all
}
vlib work
vlog  pc.v regFile.v shiftLeftBy2.v signExtend.v mux2in1.v lab1_tb.v
vsim -t 1ns -voptargs="+acc" testbench
#def clk
add wave testbench/clk

#mux2in1
add wave -radix unsigned /testbench/dat0
add wave -radix unsigned /testbench/dat1
add wave -radix unsigned /testbench/control
add wave -radix unsigned /testbench/odat


#signExtend
add wave /testbench/idat_Se
add wave /testbench/en_Se
add wave /testbench/odat_Se


#PC
add wave /testbench/i_rst_n_pc
add wave -radix unsigned /testbench/i_pc
add wave -radix unsigned /testbench/o_pc


#shiftLeftBy2
add wave /testbench/i_data_Slby2
add wave /testbench/o_data_Slby2


#regFile
add wave -radix unsigned /testbench/i_raddr1
add wave -radix unsigned /testbench/i_raddr2
add wave -radix unsigned /testbench/i_waddr
add wave -radix unsigned /testbench/i_wdata
add wave /testbench/i_we
add wave -radix unsigned /testbench/regFile/register
add wave -radix unsigned /testbench/o_rdata1
add wave -radix unsigned /testbench/o_rdata2

onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full
