; My-OS day1
; for FAT12 FD
; see http://hrb.osask.jp/wiki/?tools/nask and the book
    DB      0xeb, 0x4e, 0x90
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
    DB      0xb8, 0x00, 0x00, 0x8e, 0xd0, 0xbc, 0x00, 0x7c
    DB      0x8e, 0xd8, 0x8e, 0xc0, 0xbe, 0x74, 0x7c, 0x8a
    DB      0x04, 0x83, 0xc6, 0x01, 0x3c, 0x00, 0x74, 0x09
    DB      0xb4, 0x0e, 0xbb, 0x0f, 0x00, 0xcd, 0x10, 0xeb
    DB      0xee, 0xf4, 0xeb, 0xfd

; Message
    DB      0x0a, 0x0a
    DB      "hello, world"
    DB      0x0a
    DB      0

    TIMES   0x1fe-($-$$) DB 0

    DB      0x55, 0xaa

; Others
    DB      0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    TIMES   4600 DB 0
    DB      0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    TIMES   1469432 DB 0