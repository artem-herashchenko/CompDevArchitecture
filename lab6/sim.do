transcript on

if { [file exists "work"] } {
    vdel -all
}
vlib work
vlog  alu.v aluControl.v adder.v rom.v ram.v control.v nextPC.v pc.v regFile.v signExtend.v mux2in1.v mux3in1.v mux4in1.v register.v hazardDetect.v core.v lab6_tb.v 
vsim -t 1ns -voptargs="+acc" testbench


add wave /testbench/core_tb/*


add wave /testbench/core_tb/hazardDetect/*
add wave /testbench/core_tb/regFile/register
add wave /testbench/core_tb/data_memory/ram_mem
onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full