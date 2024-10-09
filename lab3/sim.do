transcript on

if { [file exists "work"] } {
    vdel -all
}
vlib work
vlog  control.v lab3_tb.v
vsim -t 1ns -voptargs="+acc" testbench

#control
add wave /testbench/i_instrCode
add wave /testbench/o_regDst
add wave /testbench/o_regWrite
add wave /testbench/o_ExtOp
add wave /testbench/o_aluSrc
add wave /testbench/o_beq
add wave /testbench/o_bne
add wave /testbench/o_jump
add wave /testbench/o_memRead
add wave /testbench/o_memWrite
add wave /testbench/o_memToReg

onbreak resume

configure wave -timelineunits ns
run -all

wave zoom full