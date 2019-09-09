; syscall
[BITS 32]
        GLOBAL      io_hlt,write_mem8
[SECTION .text]
;; io_hlt fuction
io_hlt:	; void io_hlt(void);
        HLT
        RET
write_mem8: ; void write_mem8(int addr, int data);
        MOV     ECX,[ESP+4]     ; read addr
        MOV     AL,[ESP+8]      ; read data
        MOV     [ECX],AL
        RET