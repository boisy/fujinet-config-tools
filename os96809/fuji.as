********************************************************************
* fuji - FujiNet routines
*
* $Id$
*
* Edt/Rev  YYYY/MM/DD  Modified by
* Comment
* ------------------------------------------------------------------
*   1      2024/09/12  Boisy G. Pitre
* Started.

                    section   bss
fujipath            rmb       1                    
nbufferl            equ       128
response            rmb       256
nbuffer             rmb       nbufferl
                    endsect

                    section   fujisymbols,constant
OP_FUJI             equ     $E2
FN_SCAN_NETWORKS    equ   $FD
FN_SET_DEVICE_FULLPATH  equ       $E2
FN_GET_DEVICE_FULLPATH	equ	   0xDA
FN_MOUNT_IMAGE      equ       $F8
FN_READ_DEVICE_SLOTS equ $F2
FN_READ_HOST_SLOTS equ $F4
	export     OP_FUJI
	export     FN_SCAN_NETWORKS
	export     FN_SET_DEVICE_FULLPATH
	export     FN_GET_DEVICE_FULLPATH
	export     FN_MOUNT_IMAGE
                    export     FN_READ_DEVICE_SLOTS
                    export     FN_READ_HOST_SLOTS
                    endsect
                    
                    section   code


space               fcb       C$SPAC
devnam              fcs       "/fuji"

getopts             leax      nbuffer,u
                    ldb       #SS.Opt
                    os9       I$GetStt
                    rts

setopts             leax      nbuffer,u
                    ldb       #SS.Opt
                    os9       I$SetStt
                    rts

* Set Echo On
*
* Entry:  None
*
* Exit:   A = Path to the FujiNet server.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
SetEchoOn           pshs      a,x
                    bsr       getopts
                    bcs       rawex
                    ldb       #1
                    stb       PD.EKO-PD.OPT,x
                    bsr       setopts
                    puls      a,x,pc


* Set Echo Off
*
* Entry:  None
*
* Exit:   A = Path to the FujiNet server.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
SetEchoOff          pshs      a,x
                    bsr       getopts
                    bcs       rawex
                    clr       PD.EKO-PD.OPT,x
                    bsr       setopts
                    puls      a,x,pc


* Set Auto Linefeed On
*
* Entry:  None
*
* Exit:   A = Path to the FujiNet server.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
SetAutoLFOn         pshs      a,x
                    bsr       getopts
                    bcs       rawex
                    ldb       #1
                    stb       PD.ALF-PD.OPT,x
                    bsr       setopts
                    puls      a,x,pc


* Set Auto Linefeed Off
*
* Entry:  None
*
* Exit:   A = Path to the FujiNet server.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
SetAutoLFOff        pshs      a,x
                    bsr       getopts
                    bcs       rawex
                    clr       PD.ALF-PD.OPT,x
                    bsr       setopts
                    puls      a,x,pc


* Put the path in raw mode
*
* Entry:  None
*
* Exit:   A = Path to the FujiNet server.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
*        CC = Carry flag set to indicate error.
RawPath             pshs      a,x
                    bsr       getopts
                    bcs       rawex
                    leax      PD.UPC-PD.OPT,x
                    ldb       #PD.QUT-PD.UPC
rawloop             clr       ,x+
                    decb
                    bpl       rawloop
                    bsr       setopts
rawex               puls      a,x,pc


* Open the path to the FujiNet server
*
* Entry:  None
*
* Exit:   A = Path to the FujiNet server.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
*        CC = Carry flag set to indicate error.
                    export    FNOpen 
FNOpen              pshs      x,y
                    lda       #UPDAT.
                    leax      devnam,pcr
                    os9       I$Open
                    bcs       ex@
                    sta       fujipath,u
                    bsr       RawPath
ex@                 puls      x,y,pc

* Close the path to the FujiNet server
*
* Entry:  None
*
* Exit:  CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
*         Y = The address of the first non-delimiter character.
*        CC = Carry flag set to indicate error.
                    export    FNClose 
FNClose             lda       fujipath,u
                    os9       I$Close
                    clr       fujipath,u
                    rts

* Write to the FujiNet server
*
* Entry:  X = Address of data to write.
*         Y = Number of bytes to write.
*
* Exit:   CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
*        CC = Carry flag set to indicate error.
                    export    FNWrite
FNWrite             pshs      a
                    ldb       #SS.BlkWr
                    lda       fujipath,u
                    os9       I$SetStt
                    puls      a,pc

* FujiNet Send Response Command
*
* Entry:  Y = Number of bytes to write.
*
* Exit:   X = Response from last FujiNet command.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
*        CC = Carry flag set to indicate error.
FN_SEND_RESPONSE    equ     $01
                    export    FNSendResponse 
FNSendResponse      pshs      d,y
                    ldd       #OP_FUJI*256+FN_SEND_RESPONSE
                    pshs      d
                    leax      ,s
                    lda       fujipath,u
                    ldy       #2
                    ldb       #SS.BlkWr
                    os9       I$SetStt
                    leas      2,s
                    bcs       ex@
                    leax      response,u
                    ldy       2,s
                    os9       I$Read
                    bcs       ex@
ex@                 puls      d,y,pc
            
* FujiNet Send Error Command
*
* Entry:  None.
*
* Exit:   B = FujiNet error code.
*        CC = Carry flag clear to indicate success.
*
* Error:  B = A non-zero error code.
*        CC = Carry flag set to indicate error.
FN_SEND_ERROR       equ       $02
                    export    FNSendResponse 
FNSendError         pshs      d,y
                    ldd       #OP_FUJI*256+FN_SEND_ERROR
                    pshs      d
                    leax      ,s
                    lda       fujipath,u
                    ldy       #2
                    ldb       #SS.BlkWr
                    os9       I$SetStt
                    leas      2,s
                    bcs       ex@
                    leax      response,u
                    ldy       #2
                    os9       I$Read
                    bcs       ex@
                    ldb       response,u
ex@                 puls      d,y,pc
            
                    endsect
