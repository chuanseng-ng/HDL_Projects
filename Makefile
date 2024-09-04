## Purpose - Create a UVM TB template for the working directory

work = work

#top_tb_name = top_uvm_tb
#TOP_TB_NAME = traffic_light_control_uvm_tb
#PROJ_NAME   = Traffic_Light_Control

ifeq ($(OS),Windows_NT)
	ifeq ($(SHELL),sh.exe)
		ori_dir := %cd%
	else
		ori_dir := $(shell pwd)
	endif
else
	ori_dir := $(shell pwd)
endif

help:
	@echo "####################################################################"
	@echo "Purpose - Create a UVM or SV TB template for the specified directory"
	@echo "####################################################################"
	@echo "Commands -"
	@echo "- test       -- Test command to check if current directory is correct"
	@echo "- gen_sv_tb  -- Generate System Verilog Testbench template"
	@echo "- gen_uvm_tb -- Generate UVM Testbench template"

test:
	@echo $(SHELL)

gen_uvm_tb:
	@echo ${TOP_TB_NAME}
	@echo ${PROJ_NAME}
	@echo ${ori_dir}
	@cd ../tbengy && python tbengy.py -m $(TOP_TB_NAME) -t uvm -d ${ori_dir}/${PROJ_NAME}

gen_sv_tb:
	@cd ../tbengy && python tbengy.py -m ${TOP_TB_NAME} -t sv  -d ${ori_dir}/${PROJ_NAME}