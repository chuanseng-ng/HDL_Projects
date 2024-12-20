# @Author : waele
# @Date   : 2024-09-04

work = work

top_tb_name = fifo_mem_tb_uvm

ifeq ($(OS),Windows_NT)

ifneq ("$(wildcard ../rtl)","")
INCRTL = +incdir+../rtl
else
INCRTL =
endif

ifneq ("$(wildcard ../rtl/*.sv)","")
RTL = ../rtl/fifo_mem.sv
else
RTL = "-f ../sim/filelist"
endif

ifneq ("$(wildcard ../sim/tb)","")
INCTB = +incdir+../sim/tb
else
INCTB =
endif

ifneq ("$(wildcard ../sim/tb/*.sv)","")
TB = ../sim/tb/fifo_mem_tb_uvm.sv
else
TB =
endif

ifneq ("$(wildcard ../sim/env/agent)","")
INCINTF = +incdir+../sim/env/agent
else
INCINTF =
endif

ifneq ("$(wildcard ../sim/env/agent/*intf.sv)","")
INTF = ../sim/env/agent/fifo_mem_intf.sv
else
INTF =
endif

ifneq ("$(wildcard ../sim/env/agent)","")
INCAGT = +incdir+../sim/env/agent
else
INCAGT =
endif

ifneq ("$(wildcard ../sim/env/agent/*pkg.sv)","")
AGT = ../sim/env/agent/fifo_mem_agent_pkg.sv
else
AGT =
endif

ifneq ("$(wildcard ../sim/env/agent/sequence_lib)","")
INCSEQ_LIB = +incdir+../sim/env/agent/sequence_lib
else
INCSEQ_LIB =
endif

ifneq ("$(wildcard ../sim/env/agent/sequence_lib/*pkg.sv)","")
SEQ_LIB = ../sim/env/agent/sequence_lib/fifo_mem_seq_pkg.sv
else
SEQ_LIB =
endif

ifneq ("$(wildcard ../sim/env)","")
INCENV = +incdir+../sim/env
else
INCENV =
endif

ifneq ("$(wildcard ../sim/env/*pkg.sv)","")
ENV = ../sim/env/fifo_mem_env_pkg.sv
else
ENV =
endif

ifneq ("$(wildcard ../sim/env/agent/regs)","")
INCREG = +incdir+../sim/env/agent/regs
else
INCREG =
endif

ifneq ("$(wildcard ../sim/env/agent/regs/*pkg.sv)","")
REG = ../sim/env/agent/regs/fifo_mem_regs_pkg.sv
else
REG =
endif

ifneq ("$(wildcard ../sim/tests)","")
INCTESTS = +incdir+../sim/tests
else
INCTESTS =
endif

ifneq ("$(wildcard ../sim/tests/*pkg.sv)","")
TESTS = ../sim/tests/fifo_mem_test_pkg.sv
else
TESTS =
endif

else

ifneq ("$(wildcard ../rtl)","")
INCRTL = +incdir+../rtl
else
INCRTL =
endif

ifneq ("$(wildcard ../rtl/*.sv)","")
RTL = ../rtl/*.sv
else
RTL =
endif

ifneq ("$(wildcard ../sim/tb)","")
INCTB = +incdir+../sim/tb
else
INCTB =
endif

ifneq ("$(wildcard ../sim/tb/*.sv)","")
TB = ../sim/tb/*.sv
else
TB =
endif

ifneq ("$(wildcard ../sim/env/agent)","")
INCINTF = +incdir+../sim/env/agent
else
INCINTF =
endif

ifneq ("$(wildcard ../sim/env/agent/*intf.sv)","")
INTF = ../sim/env/agent/*intf.sv
else
INTF =
endif

ifneq ("$(wildcard ../sim/env/agent)","")
INCAGT = +incdir+../sim/env/agent
else
INCAGT =
endif

ifneq ("$(wildcard ../sim/env/agent/*pkg.sv)","")
AGT = ../sim/env/agent/*pkg.sv
else
AGT =
endif

ifneq ("$(wildcard ../sim/env/agent/sequence_lib)","")
INCSEQ_LIB = +incdir+../sim/env/agent/sequence_lib
else
INCSEQ_LIB =
endif

ifneq ("$(wildcard ../sim/env/agent/sequence_lib/*pkg.sv)","")
SEQ_LIB = ../sim/env/agent/sequence_lib/*pkg.sv
else
SEQ_LIB =
endif

ifneq ("$(wildcard ../sim/env)","")
INCENV = +incdir+../sim/env
else
INCENV =
endif

ifneq ("$(wildcard ../sim/env/*pkg.sv)","")
ENV = ../sim/env/*pkg.sv
else
ENV =
endif

ifneq ("$(wildcard ../sim/env/agent/regs)","")
INCREG = +incdir+../sim/env/agent/regs
else
INCREG =
endif

ifneq ("$(wildcard ../sim/env/agent/regs/*pkg.sv)","")
REG = ../sim/env/agent/regs/*pkg.sv
else
REG =
endif

ifneq ("$(wildcard ../sim/tests)","")
INCTESTS = +incdir+../sim/tests
else
INCTESTS =
endif

ifneq ("$(wildcard ../sim/tests/*pkg.sv)","")
TESTS = ../sim/tests/*pkg.sv
else
TESTS =
endif

endif

ifeq ($(OS),Windows_NT)
	ifeq ($(SHELL),sh.exe)
		DELFILES := clean_dos
	else
		DELFILES := clean_linux
	endif
else
	DELFILES := clean_linux
endif

# 	xvlog -work $(work) -i ../sim -sv $(RTL) $(SEQ_LIB) $(REG) $(INTF) $(AGT) $(ENV) $(TESTS) $(TB) -L uvm
cmp:
	xvlog -work $(work) -i ../sim -sv -f ../sim/filelist $(SEQ_LIB) $(REG) $(INTF) $(AGT) $(ENV) $(TESTS) $(TB) -L uvm
	xelab work.$(top_tb_name) -s $(top_tb_name)_sim -L uvm -timescale 1ns/1ps -debug all

run_sim_wave:
	xsim -wdb sim.wdb -log session.log -t logw.tcl $(top_tb_name)_sim --testplusarg "{ UVM_TESTNAME=fifo_mem_sanity_test }"
	xsim sim.wdb -gui

view_wave:
	xsim sim.wdb -gui

run_sim:
	xsim -runall -log session.log $(top_tb_name)_sim -testplusarg "{ UVM_TESTNAME=fifo_mem_sanity_test }"

clean_linux:
	rm -rf modelsim.* transcript* vlog.* work vsim.wlf *.log *hbs *Xil xsim.dir *.jou *.pb
	clear

clean_dos:
	if exist modelsim.* del modelsim.* /F /S /Q /A
	if exist transcript* del transcript* /F /S /Q /A
	if exist vlog.* del vlog.* /F /S /Q /A
	if exist vsim.wlf del vsim.wlf /F /S /Q /A
	if exist *.log del *.log /F /S /Q /A
	if exist work rd work /q /s
	if exist covhtmlreport rd covhtmlreport /q /s
	if exist *hbs del *hbs /q /s
	if exist *Xil del *Xil /q /s
	if exist xsim.dir del xsim.dir /q /s
	if exist *.jou del *.jou /F /S /Q /A
	if exist *.pb del *.pb /F /S /Q /A

clean_log:
	if exist *.log del *.log /f /s /q /a

clean:
	make $(DELFILES)

run_all:
	make clean
	make cmp
	make run_sim

run_all_gui:
	make clean
	make cmp
	make run_sim_wave

run_all_dirty:
	make cmp
	make run_sim
