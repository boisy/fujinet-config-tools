
        		    section   bss
opcodes             rmb       2
sbuff               rmb       10
					endsect
					
                    section   code

help                lbsr      PRINTS
                    fcc       /Usage: getwifienabled/
                    fcb       C$CR,0
					rts

					export    GetWifiEnabled
GetWifiEnabled      tst       ,x
					bne       help
                    pshs      d,y
					lbsr      FNOpen
                    bcs       ex@
                    ldd       #OP_FUJI*256+FN_GET_WIFI_ENABLED
					std       opcodes,u
					leax      opcodes,u
					ldy       #2
					lbsr      FNWrite
					bcs       ex@
					ldy       #1
					lbsr      FNSendResponse
					lbsr      PRINTS
					fcc       "Wi-Fi "
					fcb       $0
					tst       ,x
					bne       showenabled@
					lbsr      PRINTS
					fcc       "dis"
					fcb       $0
					bra       rest@
showenabled@        lbsr      PRINTS
					fcc       "en"
					fcb       $0
rest@               lbsr      PRINTS
					fcc       "abled"
					fcb       $0
                    lbsr      PUTCR					
ex@                 puls      d,y,pc                                                                                                   
