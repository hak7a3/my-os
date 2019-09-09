; My-OS day2
; see http://hrb.osask.jp/wiki/?tools/nask and the book
    ORG             0x7c00      ; start address of this program (boot sector)
; for FAT12 FD
    JMP     SHORT entry
    DB      0x90
    DB      "HELLOIPL"          ; name of boot sector (8 byte)
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
    DB      "HELLO-OS   "       ; disk name (11 byte)
    DB      "FAT12   "          ; format name (8 byte)
    TIMES   18 DB 0             ; space

; program main

entry:
    ;; format all registers
    MOV     AX,0
    MOV     SS,AX
    MOV     SP,0x7c00           ; naruhodo, koko de SP zurasu noka
    MOV     DS,AX
    MOV     ES,AX

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
    DB      "hogeeeeeeeee"
    DB      0x0a
    DB      0

    TIMES   0x1fe-($-$$) DB 0

    DB      0x55, 0xaa
