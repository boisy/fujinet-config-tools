                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: getdevfile <device_slot>/
                    fcb       C$CR,0
					rts
					
					export    GetDevFile
GetDevFile          tst       ,x
					beq       help
                    lbsr      FNOpen
                    bcs       ex@
                    lbsr      DEC_BIN
                    pshs      b
                    ldd       #OP_FUJI*256+FN_GET_DEVICE_FULLPATH
					pshs      d
					leax      ,s
					ldy       #3
					lbsr      FNWrite
					leas      3,s
					bcs       ex@
                    ldy       #256
					lbsr      FNSendResponse
					lbsr      PUTS
					lbra      FNClose					                   
ex@                 rts                                                                                                   

                    endsect
