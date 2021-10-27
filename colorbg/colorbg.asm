        processor 6502

        include "vcs.h"
        include "macro.h"

        seg code
        org $F000

Start:
        CLEAN_START

;;; set the background color
        lda #$1E                ; load the literal hex $1E (yellow)      
        sta COLUBK              ; store A to the background color address $09

        jmp Start

        org $FFFC
        .word Start
        .word Start
        
