
        		    section   bss
opcodes             rmb       2
sbuff               rmb       10
					endsect
					
                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: mountall/
                    fcb       C$CR,0
					rts

					export    MountAll
MountAll            tst       ,x
					bne       help
                    pshs      d,y
					lbsr      FNOpen
                    bcs       ex@
                    ldd       #OP_FUJI*256+FN_MOUNT_ALL
					std       opcodes,u
					leax      opcodes,u
					ldy       #2
					lbsr      FNWrite
ex@                 puls      d,y,pc                                                                                                   
