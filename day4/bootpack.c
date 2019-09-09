void io_hlt(void);
void write_mem8(int addr, int data);

void hrmain() {

    int i;

    for(i = 0xa0000; i <= 0xaffff; i++) {
        write_mem8(i, 10); // write green
    }

    for(;;) { io_hlt(); }
}
