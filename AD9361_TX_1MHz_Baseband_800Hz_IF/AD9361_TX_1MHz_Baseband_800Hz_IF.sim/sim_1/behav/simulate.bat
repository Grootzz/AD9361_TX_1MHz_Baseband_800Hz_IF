@echo off
set xv_path=D:\\XilinxVivado\\Vivado\\2017.1\\bin
call %xv_path%/xsim dds_test_behav -key {Behavioral:sim_1:Functional:dds_test} -tclbatch dds_test.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
