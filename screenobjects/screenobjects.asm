    processor 6502

;;; Includes
    include "../vcs.h"
    include "../macro.h"

;;; player variables
    seg.u Variables
    org $80
P0Height .byte
P1Height .byte

;;; Start ROM 
    seg Code
    org $f000

Reset:
    CLEAN_START             ; clear ram and tia

    ldx #$80                ; set background to blue
    stx COLUBK

    ldx #%1111              ; white playingfield
    stx COLUPF

;;; set the player height values
    lda #10
    sta P0Height
    sta P1Height

;;; Set the TIA registers for the players to the corresponding colors
    lda #$48               ; set player 0 to light red
    sta COLUP0

    lda #$C6                ; set player 1 to light green
    sta COLUP1

    ldy #%00000010 
    sty CTRLPF              ; set to 1 means score

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

VisibleScanlines:
    
    ;; draw 10 empty lines at the top of the frame
    REPEAT 10
        sta WSYNC
    REPEND

;; scoreboard
    ldy #0
ScoreboardLoop:
    lda NumberBitmap,Y 
    sta PF1
    sta WSYNC
    iny
    cpy #10                     ; compare Y reg with #10
    bne ScoreboardLoop          ; if the previous comparison is false (0)
                                ; repeat the ScoreboardLoop (this is a while loop)

    lda #0
    sta PF1

    REPEAT 50
        sta WSYNC
    REPEND

;; player 0 loop
    ldy #0
Player0Loop:
    lda PlayerBitmap,Y 
    sta GRP0
    sta WSYNC
    iny
    cpy P0Height                ; compare Y with the P0Height value
    bne Player0Loop             ; if not equal (i.e not zero) loop

    lda #0
    sta GRP0                    ; end player 0 graphics

;; player 1 loop
    ldy #0
Player1Loop:
    lda PlayerBitmap,Y 
    sta GRP1
    sta WSYNC
    iny
    cpy P1Height                ; compare Y with the P1Height value
    bne Player1Loop             ; if not equal (i.e not zero) loop

    lda #0
    sta GRP1                    ; end player 0 graphics

;;; finish drawing rest of background before the overflow
    REPEAT 102 
        sta WSYNC
    REPEND


;; overflow
    REPEAT 30
        sta WSYNC
    REPEND

    jmp StartFrame



;;; define the bitmapts for objects we want to display on the frame
;;; knowing that the rom ends at mem address FFFC we want to use the 
;;; previous 20 bytes (10 per bitmap) to store the two bitmaps.
;;; For this reason we start the first bitmap at FFE8 (20 away from FFFC)
;;; and the second one at FFF2 (10 away from FFFC).
    org $FFE8
PlayerBitmap:
    .byte #%01111110   ;  ######
    .byte #%11111111   ; ########
    .byte #%10011001   ; #  ##  #
    .byte #%11111111   ; ########
    .byte #%11111111   ; ########
    .byte #%11111111   ; ########
    .byte #%10111101   ; # #### #
    .byte #%11000011   ; ##    ##
    .byte #%11111111   ; ########
    .byte #%01111110   ;  ######

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defines an array of bytes to draw the scoreboard number.
;; We add these bytes in the final ROM addresses.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFF2
NumberBitmap:
    .byte #%00001110   ; ########
    .byte #%00001110   ; ########
    .byte #%00000010   ;      ###
    .byte #%00000010   ;      ###
    .byte #%00001110   ; ########
    .byte #%00001110   ; ########
    .byte #%00001000   ; ###
    .byte #%00001000   ; ###
    .byte #%00001110   ; ########
    .byte #%00001110   ; ########

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete ROM size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC
    .word Reset
    .word Reset

