        processor 6502

        include "vcs.h"
        include "macro.h"

        seg code
        org $F000

Start:
        CLEAN_START
        
;;; start new frame
NextFrame:
        lda #2                  ; store the value 2 in A
        sta VBLANK              ; turn on vlank
        sta VSYNC

        sta WSYNC               ; sync with PIA
        sta WSYNC               ; sync with PIA
        sta WSYNC               ; sync with PIA

        lda #0
        sta WSYNC               ; turn off VBLANK

        ldx #37
LoopVBlank:
        sta WSYNC               ; wait for the wsync
        dex                     ; decrement counter
        bne LoopVBlank          ; loop while X != 0

        lda #0
        sta VBLANK              ; turn off vblank

;;; darw the 192 visible scanlines
        ldx #192                ; start the counter with 192
LoopVisible:
        stx COLUBK              ; set the background color
        sta WSYNC               ; wait for the TIA
        dex
        bne LoopVisible

;;; draw the overscan
        lda #2                  ; start the vblank
        sta VBLANK

        ldx #30                 ; start counter at 30
LoopOverscan:
        sta WSYNC
        dex
        bne LoopOverscan

        jmp NextFrame

        org $FFFC
        .word
        .word Start
        
