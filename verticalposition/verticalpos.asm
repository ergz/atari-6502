    processor 6502

;;; Includes
    include "../vcs.h"
    include "../macro.h"

;;; player variables
    seg.u Variables         ; set an uninitialized segment in RAM
    org $80                 ; set this at the position $80
P0Height byte               ; set the p0 sprite height to be a byte in size 
PlayerYPos byte             ; set the y position for the player to be a byte in size

;;; Start ROM 
    seg Code
    org $F000

Reset:
    CLEAN_START             ; clear ram and tia

    ldx #$00                ; set background to black
    stx COLUBK

;;; Initialize the variables we created above

    lda #180
    sta PlayerYPos          ; set the player y position to start at 180

    lda #9
    sta P0Height            ; set the height of the sprite to be 9


;;; Draw to Frame
StartFrame:

    lda #2
    sta VBLANK              ; enable vblank                  
    sta VSYNC               ; enable vsync

    REPEAT 3
        sta WSYNC
    REPEND
    lda #0 
    sta VSYNC

    REPEAT 37
        sta WSYNC
    REPEND
    lda #0 
    sta VBLANK

;;; Draw the visible 192 scanlines ----------------------------


;;; Plan: the overall plan here is to countdown the scanlines each time we will
;;; subtract the Y position for the player to determine if we are in range of the 
;;; of the sprite that we need to draw, if so we will jump to the LoadBitmap "subroutine"

    ldx #192                ; use X as the counter

Scanline:
    txa                     ; transfer X to A
    sec                     ; since we will subtract make sure carry flag is set
    sbc PlayerYPos          ; subtract the sprite Y coordinate
    cmp P0Height            
    bcc LoadBitmap          ; if the results is such that < SpriteHeight call LoadBitmap
    lda #0

LoadBitmap:
    tay
    lda P0Bitmap,Y 

    sta WSYNC

    sta GRP0

    lda P0Color,Y 

    sta COLUP0 

    dex
    bne Scanline



;; overflow
Overscan:
    lda #2
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND


    dec PlayerYPos


    jmp StartFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lookup table for the player graphics bitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P0Bitmap:
    byte #%00000000
    byte #%00101000
    byte #%01110100
    byte #%11111010
    byte #%11111010
    byte #%11111010
    byte #%11111110
    byte #%01101100
    byte #%00110000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lookup table for the player colors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
P0Color:
    byte #$00
    byte #$40
    byte #$40
    byte #$40
    byte #$40
    byte #$42
    byte #$42
    byte #$44
    byte #$D2



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC
    word Reset
    word Reset

