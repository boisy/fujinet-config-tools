                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: scannetworks/
                    fcb       C$CR,0
					rts
					
					export    ScanNetworks
ScanNetworks        tst       ,x
					bne       help
                    lbsr      FNOpen
                    bcs       ex@
                    lbsr      DEC_BIN
                    pshs      b
                    ldd       #OP_FUJI*256+FN_SCAN_NETWORKS
					pshs      d
					leax      ,s
					ldy       #3
					lbsr      FNWrite
					leas      3,s
					bcs       ex@
                    ldy       #1
					lbsr      FNSendResponse
					ldb       ,x
					clra
					lbsr      BIN_DEC
					pshs      x
					lbsr      PRINTS
					fcc       /Wireless networks found: /
					fcb       0
					puls      x
					lbsr      PUTS
					lbsr      PUTCR
					lbra      FNClose					                   
ex@                 rts                                                                                                   

                    endsect
