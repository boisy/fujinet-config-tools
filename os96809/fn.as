********************************************************************
* fn - FujiNet utility
*
* This utility parses command arguments through a function table, e.g.:
*
*     fn getdevfile 1
*     fn setdevfile 1 1 3 embargo
*
* Edt/Rev  YYYY/MM/DD  Modified by
* Comment
* ------------------------------------------------------------------
*   1      2024/09/11  Boisy Gene Pitre
* Created.

DEBUG               set       0

                    section   __os9
type                equ       Prgrm
lang                equ       Objct
attr                equ       ReEnt
rev                 equ       $00
edition             equ       1
stack               equ       200
                    endsect

                    section   bss
noparms			    rmb       1					
                    endsect

                    section   code

* Function table
FuncTbl             fdb       GetDevFile-FuncTbl
                    fcc       "getdevfile"
                    fcb       $0

                    fdb       SetDevFile-FuncTbl
                    fcc       "setdevfile"
                    fcb       $0

                    fdb       ScanNetworks-FuncTbl
                    fcc       "scannetworks"
                    fcb       $0

                    fdb       ReadDevSlots-FuncTbl
                    fcc       "readdevslots"
                    fcb       $0

                    fdb       ReadHostSlots-FuncTbl
                    fcc       "readhostslots"
                    fcb       $0

                    fdb       $0

* Help message
help                lbsr      PRINTS
                    fcc       /Usage: fn <cmd> <opts>/
                    fcb       C$CR,0
					leax      FuncTbl,pcr
					lbsr      PRINTS
					fcc       "Commands:"
					fcb       $0D
					fcb       $00
p@
        			ldy       ,x++
					lbeq      exit
					lbsr      PRINTS
					fcc       "   "
					fcb       $0
					lbsr      PUTS
					lbsr      PUTCR
					lbsr      TO_NIL
					leax      1,x
					bra       p@
					
* Entry point
*
* Here's how registers are set when this process is forked:
*
*   +-----------------+  <--  Y          (highest address)
*   !   Parameter     !
*   !     Area        !
*   +-----------------+  <-- X, SP
*   !   Data Area     !
*   +-----------------+
*   !   Direct Page   !
*   +-----------------+  <-- U, DP       (lowest address)
*
*   D = parameter area size
*  PC = module entry point abs. address
*  CC = F=0, I=0, others undefined
				    export	  __start
__start				subd      #$0001			subtract carriage return from parameter size length.
					beq       help        		branch if D = 0 (no parameters)
					      
	                clr       d,x				write $00 over carriage return

* Parse command argument
                    clr       noparms,u			clear our "no parameters flag"
                    pshs      x,u
					lbsr      TO_SP_OR_NIL      skip over first parameter
					tst       ,x				is the character at X $00?
					bne       gotparms@			branch if not (we have parameters after the command argument)
					inc       noparms,u			else increment the parameters flag
gotparms@
					clr       ,x              	terminate the nil after the command argument
                    leau      >FuncTbl,pcr      point to table of supported functions
l1@                 ldy       ,u++              get pointer to subroutine
                    beq       help              if $0000, we're at the end of our search -- show help
                    ldx       ,s                get pointer to function name we were sent
l2@                 lda       ,x+               get character from caller
                    eora      ,u+               force matching case and compare with table entry
                    anda      #$DF              set case
                    beq       match@            matched, skip ahead
                    leau      -1,u              bump table pointer back one
l3@                 tst       ,u+               last character nil?
                    bne       l3@               no, keep scanning till we find end of table entry text
                    bra       l1@               check next table entry
match@              tst       -1,u              was matching character 0? (we hit end of function name?)
                    bne       l2@               no, check next character
                    leas      2,s               yes, function found. 
                    puls      u                 get statics back
					
					tst       noparms,u
					beq       l@
					leax      -1,x
l@

					lbsr      TO_NON_SP_OR_NIL					

                    tfr       y,d                 copy jump table offset to D
                    leay      >FuncTbl,pcr        point to table of supported functions again
                    leay      d,y                 add offset
                    jsr       ,y                  call function subroutine & return from there

exit           		clrb
errex       		os9		  F$Exit

					export    TO_SP_OR_NIL
TO_SP_OR_NIL        pshs      b
spl@                ldb       ,x+
                    beq       ok@
                    cmpb      #$20                is it space?
                    bne       spl@                no, loop
ok@                 leax      -1,x                point to space or nil
                    puls      b,pc

					export    TO_NON_SP_OR_NIL
TO_NON_SP_OR_NIL    pshs      b
spl@                ldb       ,x+
                    beq       ok@
                    cmpb      #$20                is it space?
                    beq       spl@                yes, loop
ok@                 leax      -1,x                point to space or nil
                    puls      b,pc

					export    TO_NIL
TO_NIL              pshs      b
spl@                ldb       ,x+
                    bne       spl@
                    leax      -1,x                point to space or nil
                    puls      b,pc

                    endsect
