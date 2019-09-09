; My-OS day3
; see http://hrb.osask.jp/wiki/?tools/nask and the book
CYLS    EQU     10

        ORG     0x7c00              ; start address of this program (boot sector)
; for FAT12 FD
        JMP     SHORT entry
        DB      0x90
        DB      "HARIBOTE"          ; name of boot sector (8 byte)
        DW      512                 ; size of a sector (must be 512)
        DB      1                   ; size of cluster (mst be 1)
        DW      1                   ; start of FAT (normally 1)
        DB      2                   ; #FAT (must be 2)
        DW      224                 ; size of root directory (normally 224)
        DW      2880                ; size of drive (must be 2880)
        DB      0xf0                ; media's type (must be 0xf0)
        DW      9                   ; length of FAT (must be 9)
        DW      18                  ; #sector / track (must be 18)
        DW      2                   ; #head (must be 2)
        DD      0                   ; must be 0 unless using partition
        DD      2880                ; size of drive
        DB      0,0,0x29            ; ???
        DD      0xffffffff          ; maybe volume serial number
        DB      "HARIBOTEOS "       ; disk name (11 byte)
        DB      "FAT12   "          ; format name (8 byte)
        TIMES   18 DB 0             ; space

; program main

entry:
    ;; format all registers
    MOV     AX,0
    MOV     SS,AX
    MOV     SP,0x7c00           ; naruhodo, koko de SP zurasu noka
    MOV     DS,AX


; read disk
    MOV     AX,0x0820
    MOV     ES,AX
    MOV     CH,0                ; cylinder 0
    MOV     DH,0                ; head 0
    MOV     CL,2                ; sector 2
readloop:
    MOV     SI,0                ; counter for fail
retry:
    MOV     AH,0x02             ; make read flag on
    MOV     AL,1                ; per 1 sector
    MOV     BX,0
    MOV     DL,0x00             ; 1st drive
    INT     0x13                ; disk BIOS
    JNC     next                ; for success
    ADD     SI,1                ; increment fail counter
    CMP     SI,5                
    JAE     error               ; fully fail
    MOV     AH,0x00
    MOV     DL,0x00
    INT     0x13                ; reset drive
    JMP     retry
next:
    MOV     AX,ES
    ADD     AX,0x0020
    MOV     ES,AX
    ADD     CL,1
    CMP     CL,18               ; read 18 sectors
    JBE     readloop
    MOV     CL,1
    ADD     DH,1
    CMP     DH,2
    JB      readloop
    MOV     DH,0
    ADD     CH,1
    CMP     CH,CYLS
    JB      readloop

;; execute haribote.sys
    MOV     [0x0ff0],CH         ; CH <- where ipl read
    JMP     0xc200

error:
    MOV     SI,msg
putloop:
    MOV     AL,[SI]
    ADD     SI,1
    CMP     AL,0
    JE      fin
    MOV     AH,0x0e             ; function of show 1 letter
    MOV     BX,15               ; collor code
    INT     0x10                ; call video BIOS
    JMP     putloop
fin:
    HLT
    JMP    fin                  ; loop infinity

msg:
    DB      0x0a, 0x0a
    DB      "load error"
    DB      0x0a
    DB      0

    TIMES   0x1fe-($-$$) DB 0

    DB      0x55, 0xaa
