        processor 6502

        include "../vcs.h"
        include "../macro.h"

        seg
        org $F000

Reset:
        CLEAN_START

        ldx #$80
        stx COLUBK

        lda #$1C
        sta COLUPF

StartFrame:
        lda #02
        sta VBLANK
        sta VSYNC

        REPEAT 3
                sta WSYNC       ; the three scanlines
        REPEND
        lda #0
        sta VSYNC

        REPEAT 37
                sta WSYNC
        REPEND
        lda #0
        sta VBLANK              ; turn off vblank

        ldx #%00000001          ; reflect the playfield
        stx CTRLPF


        
