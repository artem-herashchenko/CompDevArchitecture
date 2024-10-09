transcript on

if { [file exists "work"] } {
    vdel -all
}
vlib work
vlog  core.v adder.v alu.v aluControl.v control.v mux2in1.v pc.v ram.v regFile.v rom.v shiftLeftBy2.v signExtend.v core_tb.v
vsim -t 1ns -voptargs="+acc" testbench

#clk
add wave /testbench/i_clk

#i_rst_n
add wave /testbench/i_rst_n

#pc
add wave /testbench/core_test/pc_core/o_pc

#inst mem
add wave /testbench/core_test/rom_core/o_data

#control
add wave /testbench/core_test/control_core/i_instrCode

#redFile
add wave /testbench/core_test/regFile_core/i_raddr1
add wave /testbench/core_test/regFile_core/i_raddr2
add wave /testbench/core_test/regFile_core/i_waddr
add wave /testbench/core_test/regFile_core/o_rdata1
add wave /testbench/core_test/regFile_core/o_rdata1

#Sign Extend
add wave /testbench/core_test/signExtend_core/i_data
add wave /testbench/core_test/signExtend_core/en
add wave /testbench/core_test/signExtend_core/o_data

#alu
add wave -radix decimal /testbench/core_test/alu_core/o_result

#alu control
add wave /testbench/core_test/aluControl_core/o_aluControl

#DataMem
add wave /testbench/core_test/dataMem_core/o_data

#register
add wave /testbench/core_test/regFile_core/register

#ram
add wave /testbench/core_test/dataMem_core/ram_mem

onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full