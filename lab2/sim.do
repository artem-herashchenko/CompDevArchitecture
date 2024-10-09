transcript on

if { [file exists "work"] } {
    vdel -all
}
vlib work
vlog  adder.v alu.v aluControl.v ram.v rom.v lab2_tb.v
vsim -t 1ns -voptargs="+acc" testbench

#clk
add wave /testbench/clk

#adder
add wave -radix unsigned /testbench/i_op1
add wave -radix unsigned /testbench/i_op2
add wave -radix unsigned /testbench/o_result

#ram
add wave /testbench/i_we_ram
add wave -radix unsigned /testbench/i_addr_ram
add wave -radix unsigned /testbench/i_data_ram
add wave -radix unsigned /testbench/o_data_ram

#aluControl
add wave /testbench/i_aluOp_aluControl
add wave /testbench/i_func_aluControl
add wave /testbench/o_aluControl_aluControl

#alu
add wave -radix decimal /testbench/i_op1_alu
add wave -radix decimal /testbench/i_op2_alu
add wave /testbench/i_control_alu
add wave -radix decimal /testbench/o_result_alu
add wave /testbench/o_zf_alu

#rom
add wave /testbench/i_addr_rom
add wave /testbench/o_data_rom

onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full