;;; Set the startup code, here we are simply specifying the processor type
;;; and including some header files, as well as setting the position 
;;; where we are starting our rom

    processor 6502

    include "../vcs.h"
    include "../macro.h"

    seg
    org $F000

Reset:
    CLEAN_START

;;; Color the background and playfield

    ldx #$80                ; load color BLUE in the x registry
    stx COLUBK              ; and set it to the background color address

    lda #$1C                ; load the color YELLOW in the a registry
    sta COLUPF              ; and set it to the Color-Luminance Playfield address 

StartFrame:

;;; draw three lines of scanlines
    lda #02                 ; load literal 2 into A (activate VBLANK)
    sta VBLANK              
    sta VSYNC

    REPEAT 3
        sta WSYNC       ; the three scanlines
    REPEND
    lda #0                  ; turn off VSYNC
    sta VSYNC

    REPEAT 37
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK              ; turn off vblank

    ldx #%00000001          ; reflect the playfield
    stx CTRLPF

    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

;;; 192 lines

;; top
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

;; middle
    ldx #%00100000
    stx PF0
    ldx #%00000000
    stx PF1
    stx PF2
    REPEAT 164
        sta WSYNC
    REPEND

;; bottom
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND

;; bottom is blank just like the first seven lines
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
        sta WSYNC
    REPEND



;;; Overflow ----------------------------------
    lda #2
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK

    jmp StartFrame

    org $fffc
    .word Reset
    .word Reset

    
