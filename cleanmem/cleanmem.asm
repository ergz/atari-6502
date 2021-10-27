	processor 6502

	seg code
	org $F000		; define the code origin as F000

Start:
	sei 			; disable interrupts
	cld			; disable the BCD decimal math mode
	ldx #$FF		; load the X reigster with #$FF
	txs 			; transfer the X register to the stack pointer register

;;; Clear the region zero of ram
;;; the approach we are taking is by starting the position $FF and move back to $00
	lda #0			; A = 0
	ldx #$FF		; X is now the literal value $FF
	sta $FF

MemLoop:
	dex			; X--
	sta $0,X
	bne MemLoop		; loop until X == 0 (z flag is zero)

;;; Fill the rom size to exactly 4kb
	org $FFFC
	.word Start		; reset the vector
	.word Start
	

