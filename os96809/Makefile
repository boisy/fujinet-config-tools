CMDS = fn 
OBJS = libs/libfuji.a getdevfile.o setdevfile.o scannetworks.o readdevslots.o

DSKNAME = fntools.dsk

dsk: all
	os9 format -q -n"FujiNet OS-9 Tools" $(DSKNAME)
	os9 makdir $(DSKNAME),CMDS
	os9 copy $(CMDS) fntools.dsk,CMDS
	$(foreach file,$(CMDS),os9 attr -epe -q $(DSKNAME),CMDS/$(file);)
	
all: $(OBJS) $(CMDS)

AFLAGS = --format=obj --pragma=pcaspcr,condundefzero,undefextern,dollarnotlocal,noforwardrefmax
LFLAGS = --format=os9 -L libs -l nos96809l2 -l alib -l fuji

# Rules to make binaries and intermediate object files
%: %.o
	lwlink $(LFLAGS) $(OBJS) $^ -o$@

%.o: %.as
	lwasm $(AFLAGS) $< -o$@

libs/libfuji.a: fuji.as
	lwasm $(AFLAGS) fuji.as -ofuji.o
	lwar -c $@ fuji.o

clean:
	$(RM) $(CMDS) $(OBJS) *.o *.list *.map *.dsk
