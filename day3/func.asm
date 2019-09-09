; syscall
[BITS 32]
        GLOBAL      io_hlt
[SECTION .text]
;; io_hlt fuction
io_hlt:	; void io_hlt(void);
        HLT
        RET