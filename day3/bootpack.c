void io_hlt(void);

void hrmain() {
    for(;;) { io_hlt(); }
}
