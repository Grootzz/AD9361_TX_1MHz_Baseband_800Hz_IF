@echo off
set xv_path=D:\\XilinxVivado\\Vivado\\2017.1\\bin
call %xv_path%/xelab  -wto 3388a7a0d9cb4d0b8a5310e08b3c3d26 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot dds_test_behav xil_defaultlib.dds_test xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
