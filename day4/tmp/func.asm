; syscall
[BITS 32]
        GLOBAL      _io_hlt
[SECTION .txt]
;; io_hlt fuction
_io_hlt:	; void io_hlt(void);
        HLT
        RET