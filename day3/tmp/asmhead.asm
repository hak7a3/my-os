; haribote-os boot asm

;; macros
BOTPAK  EQU     0x00280000      ; load destination of bootpack
DSKCAC  EQU     0x00100000      ; disk cache
DSKCAC0 EQU     0x00008000      ; disk cache (real mode)

;; boot info
CYLS    EQU     0x0ff0
LEDS    EQU     0x0ff1
VMODE   EQU     0x0ff2
SCRNX	EQU		0x0ff4
SCRNY	EQU		0x0ff6
VRAM	EQU		0x0ff8


        ORG     0x2c00

;; video mode
        MOV     AL,0x13         ; VGA 320x200x8bit
        MOV     AH,0x00
        INT     0x10
        ;; save info to mem
        MOV     BYTE [VMODE],8
        MOV     WORD [SCRNX],320
        MOV     WORD [SCRNY],200
        MOV     DWORD [VRAM],0x000a0000

;; keyboard
        MOV     AH,0x02
        INT     0x16            ; keyboard BIOS
        MOV     [LEDS],AL

;; PIC
        MOV     AL,0xff
        OUT     0x21,AL
        NOP                     ; for some machines...
        OUT     0xa1,AL

        CLI                     ; stop CPU level int

;; A20GATE
        CALL    waitkbdout
        MOV     AL,0xd1
        OUT     0x64,AL
        CALL    waitkbdout
        MOV     AL,0xdf         ; enable A20
        OUT     0x60,AL
        CALL    waitkbdout

;; goto protect mode
        LGDT    [GDTR0]
        MOV     EAX,CR0
        AND     EAX,0x7fffffff  ; diable paging
        OR      EAX,0x00000001  ; protect mode
        MOV     CR0,EAX
        JMP     pipelineflush
pipelineflush:
        MOV     AX,1*8          ; readable segment 32bit
        MOV     DS,AX
        MOV     ES,AX
        MOV     FS,AX
        MOV     GS,AX
        MOV     SS,AX

;; transfar bootpack
        MOV     ESI,bootpack    ; from 
        MOV     EDI,BOTPAK      ; to
        MOV     ECX,512*2014/4
        CALL    memcpy

;; transfar disk data
;;; boot sector
        MOV     ESI,0x7c00      ; from
        MOV     EDI,DSKCAC      ; to
        MOV     ECX,512/4
        CALL    memcpy
;;; others
        MOV     ESI,DSKCAC0+512 ; from
        MOV     EDI,DSKCAC+512  ; to
        MOV     ECX,0
        MOV     CL,BYTE [CYLS]
        IMUL    ECX,512*18*2/4  ; #cylinder -> #bytes/4
        SUB     ECX,512/4       ; substract ipl
        CALL    memcpy

;; execute bootpack
        MOV     EBX,BOTPAK
        MOV     ECX,0x11a8      ; for remove hrb...
        ADD     ECX,3
        SHR     ECX,2
        JZ      skip
        MOV     ESI,0x10c8      ; from, for remove hrb...
        ADD     ESI,EBX
        MOV     EDI,0x00310000  ; to, for remove hrb...
        CALL    memcpy
skip:
        MOV     ESP,0x00310000  ; stack default, for remove hrb...
        JMP     DWORD 2*8:0x0000000b    ; for remove hrb...

waitkbdout:
        IN      AL,0x64
        AND     AL,0x02
        JNZ     waitkbdout
        RET

memcpy:
        MOV     EAX,[ESI]
        ADD     ESI,4
        MOV     [EDI],EAX
        ADD     EDI,4
        SUB     ECX,1
        JNZ     memcpy
        RET

        ALIGN   16, DB 0
GDT0:
        TIMES   8 DB 0
        DW      0xffff,0x0000,0x9200,0x00cf ; readable segment 32bit
        DW      0xffff,0x0000,0x9a28,0x0047 ; executable segment 32bit (for bootpack)

        DW      0
GDTR0:
        DW      8*3-1
        DD      GDT0

        ALIGN   16, DB 0
bootpack: