
        		    section   bss
opcodes             rmb       2
sbuff               rmb       10
					endsect
					
                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: readhostslots/
                    fcb       C$CR,0
					puls      d,y,pc

					export    ReadHostSlots
ReadHostSlots       pshs      d,y
                    lbsr      FNOpen
                    bcs       ex@
					tst       ,x
					bne       help
                    ldd       #OP_FUJI*256+FN_READ_HOST_SLOTS
					std       opcodes,u
					leax      opcodes,u
					ldy       #2
					lbsr      FNWrite
					bcs       ex@
					ldy       #32*8
					lbsr      FNSendResponse
					ldb       #8
					pshs      b
l@                  clra
                    ldb       #9
                    subb      ,s
					pshs      x
					leax      sbuff,u
					lbsr      BIN_DEC
					lbsr      PUTS
					puls      x
					ldb       #':
					lbsr      PUTC
					lbsr      PUTSPACE
					lbsr      PUTS
					lbsr      PUTCR
					leax      32,x
					dec       ,s
					bne       l@
ee@					puls      b
ex@                 puls      d,y,pc                                                                                                   
