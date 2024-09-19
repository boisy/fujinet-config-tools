        		    section   bss
opcodes             rmb       2
sbuff               rmb       10
					endsect
					
                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: readdevslots/
                    fcb       C$CR,0
					puls      d,y,pc

					export    ReadDevSlots
ReadDevSlots        pshs      d,y
                    lbsr      FNOpen
                    bcs       ex@
					tst       ,x
					bne       help
                    ldd       #OP_FUJI*256+FN_READ_DEVICE_SLOTS
					std       opcodes,u
					leax      opcodes,u
					ldy       #2
					lbsr      FNWrite
					bcs       ex@
					ldy       #38*4
					lbsr      FNSendResponse
					ldb       #4
					pshs      b
					clra
l@      			ldb       #5
                    subb      ,s
					pshs      x
					leax      sbuff,u
					lbsr      BIN_DEC
					lbsr      PUTS
					ldb       #':
					lbsr      PUTC
					lbsr      PUTSPACE
					puls      x
                    ldb       ,x+
                    pshs      x
				    leax      sbuff,u
					lbsr      BIN_DEC
					lbsr      PUTS
					lbsr      PUTSPACE
					puls      x
					ldb       ,x+
                    pshs      x
				    leax      sbuff,u
					lbsr      BIN_DEC
					lbsr      PUTS
					lbsr      PUTSPACE
					puls      x
					lbsr      PUTS
					lbsr      PUTCR
					leax      36,x
					dec       ,s
					bne       l@
ee@					puls      b
ex@                 puls      d,y,pc                                                                                                   