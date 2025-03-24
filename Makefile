PROGRAM = pasym
UNITS = Parser ArrayUtil

FPCFLAGS = -Fu.

ifdef DEBUG
  FPCFLAGS += -dDEBUG
endif

.PHONY: all clean debug

all: $(PROGRAM)

$(PROGRAM): $(UNITS:=.o) $(PROGRAM).pas
	fpc $(FPCFLAGS) $(PROGRAM).pas

%.o: %.pas
	fpc -s $(FPCFLAGS) $<

debug:
	$(MAKE) DEBUG=1

clean:
	rm -f *.o *.ppu $(PROGRAM)
