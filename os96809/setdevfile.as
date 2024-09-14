        		    section   bss
opcodes             rmb       2					
devslot             rmb       1					
hostslot            rmb       1					
mode                rmb       1					
					endsect
					
                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: setdevfile <device_slot> <host_slot> <mode> <path>/
                    fcb       C$CR,0
					puls      d,y,pc

					export    SetDevFile					
SetDevFile          pshs      d,y
                    lbsr      FNOpen
                    bcs       ex@
                    ldd       #OP_FUJI*256+FN_SET_DEVICE_FULLPATH
					std       opcodes,u
					lbsr      DEC_BIN
					stb       devslot,u
					lbsr      TO_SP_OR_NIL
					lbsr      TO_NON_SP_OR_NIL
					tst       ,x
					beq       help
					lbsr      DEC_BIN
					stb       hostslot,u
					lbsr      TO_SP_OR_NIL
					lbsr      TO_NON_SP_OR_NIL
					tst       ,x
					beq       help
					lbsr      DEC_BIN
					stb       mode,u
					lbsr      TO_SP_OR_NIL
					lbsr      TO_NON_SP_OR_NIL
					tst       ,x
					lbeq      help
					pshs      x
					leax      opcodes,u
					ldy       #5
					lbsr      FNWrite
					bcs       ex@
					puls      x
					ldy       #256
					lbsr      FNWrite
ex@                 puls      d,y,pc                                                                                                   
