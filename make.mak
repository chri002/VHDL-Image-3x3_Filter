
VHDLDIR=VHDL
WORKDIR=WORK
VCDDIR=VCD
MAIN=testBench
TIME="200ns"
#
GHDL=ghdl
GHDLFLAGS=--ieee=synopsys --std=08 
GHDLRUNFLAGS=--vcd=$(MAIN).vcd 

all : run

run : elaboration
	$(GHDL) -c $(GHDLFLAGS) -r $(MAIN) $(GHDLRUNFLAGS)
	mv $(MAIN).vcd VCD
	mv *.cf $(WORKDIR)

elaboration : analysis
	$(GHDL) -c $(GHDLFLAGS) -e $(MAIN)

analysis: clean
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/file_i.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/file_o.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/triSort.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/triMin.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/triMaxi.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/triMed.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/medFilter.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/mean8Maxi.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/almMeanFilter.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/ram.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/imageFilter.vhd
	$(GHDL) -a $(GHDLFLAGS) $(VHDLDIR)/$(MAIN).vhd

clean: force
	@rm -f $(WORKDIR)/*.cf $(VCDDIR)/*.vcd *.cf *.vcd

force:
