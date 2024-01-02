; Copyright (C) 2023 Ethan Cheng <ethan@nijika.org>
;
; This file is part of kita.
;
; kita is free software: you can redistribute it and/or modify it under the
; terms of the GNU General Public License as published by the Free Software
; Foundation, version 3 of the License.
;
; kita is distributed in the hope that it will be useful, but WITHOUT ANY
; WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
; details.
;
; You should have received a copy of the GNU General Public License along
; with kita. If not, see <https://www.gnu.org/licenses/>.

not_implemented:
	ld	a, not_implemented_err
	ld	(err), a
	ret

clear_x:
	ld	hl, X
	ld	de, X+1
	ld	bc, 7
	ld	(hl), 0
	ldir
	call	disable_stack_lift
	ret

save_x:
	; X -> last_X
	ld	de, last_X
	ld	hl, X
	ld	bc, 8
	ldir
	ret

tmp_to_X:
	; tmp -> X
	ld	de, X
	ld	hl, tmp
	ld	bc, 8
	ldir
	ret

lift_stack:
	; Z -> T
	ld	de, T
	ld	hl, Z
	ld	bc, 8
	ldir
	; Y -> Z
	ld	de, Z
	ld	hl, Y
	ld	bc, 8
	ldir
	; X -> Y
	ld	de, Y
	ld	hl, X
	ld	bc, 8
	ldir
	ret

drop_stack:
	; Y -> X
	ld	de, X
	ld	hl, Y
	ld	bc, 8
	ldir
	; Z -> Y
	ld	de, Y
	ld	hl, Z
	ld	bc, 8
	ldir
	; T -> Z
	ld	de, Z
	ld	hl, T
	ld	bc, 8
	ldir
	ret

roll_up:
	; T -> tmp
	ld	de, tmp
	ld	hl, T
	ld	bc, 8
	ldir
	call	lift_stack
	; tmp -> X
	ld	de, X
	ld	hl, tmp
	ld	bc, 8
	ldir
	call	enable_stack_lift
	ret

roll_down:
	; X -> tmp
	ld	de, tmp
	ld	hl, X
	ld	bc, 8
	ldir
	call	drop_stack
	; tmp -> T
	ld	de, T
	ld	hl, tmp
	ld	bc, 8
	ldir
	call	enable_stack_lift
	ret

enter:
	call	lift_stack
	call	disable_stack_lift
	ret

add:
	call	save_X
	or	a ; reset carry
	ld	b, 8
	ld	ix, X
add_loop:
	ld	a, (ix)
	ld	c, (ix-8)
	adc	a, c
	ld	(ix+16), a
	inc	ix
	djnz	add_loop
	call	drop_stack
	call	tmp_to_X
	call	enable_stack_lift
	ret

subtract:
	call	save_X
	or	a ; reset carry
	ld	b, 8
	ld	ix, X
subtract_loop:
	ld	a, (ix-8)
	ld	c, (ix)
	sbc	a, c
	ld	(ix+16), a
	inc	ix
	djnz	subtract_loop
	call	drop_stack
	call	tmp_to_X
	call	enable_stack_lift
	ret

; vector table for keypresses
func_table:
	.dl not_implemented ; 00 ;
	.dl not_implemented ; 01 ;
	.dl not_implemented ; 02 ;
	.dl roll_up         ; 03 ; kUp
	.dl roll_down       ; 04 ; kDown
	.dl enter           ; 05 ; kEnter
	.dl not_implemented ; 06 ;
	.dl not_implemented ; 07 ;
	.dl not_implemented ; 08 ;
	.dl clear_x         ; 09 ; kClear
	.dl clear_x         ; 0A ; kDel
	.dl not_implemented ; 0B ;
	.dl not_implemented ; 0C ;
	.dl not_implemented ; 0D ;
	.dl not_implemented ; 0E ;
	.dl not_implemented ; 0F ;
	.dl not_implemented ; 10 ;
	.dl not_implemented ; 11 ;
	.dl not_implemented ; 12 ;
	.dl not_implemented ; 13 ;
	.dl not_implemented ; 14 ;
	.dl not_implemented ; 15 ;
	.dl not_implemented ; 16 ;
	.dl not_implemented ; 17 ;
	.dl not_implemented ; 18 ;
	.dl not_implemented ; 19 ;
	.dl not_implemented ; 1A ;
	.dl not_implemented ; 1B ;
	.dl not_implemented ; 1C ;
	.dl not_implemented ; 1D ;
	.dl not_implemented ; 1E ;
	.dl not_implemented ; 1F ;
	.dl not_implemented ; 20 ;
	.dl not_implemented ; 21 ;
	.dl not_implemented ; 22 ;
	.dl not_implemented ; 23 ;
	.dl not_implemented ; 24 ;
	.dl not_implemented ; 25 ;
	.dl not_implemented ; 26 ;
	.dl not_implemented ; 27 ;
	.dl not_implemented ; 28 ;
	.dl not_implemented ; 29 ;
	.dl not_implemented ; 2A ;
	.dl not_implemented ; 2B ;
	.dl not_implemented ; 2C ;
	.dl not_implemented ; 2D ;
	.dl not_implemented ; 2E ;
	.dl not_implemented ; 2F ;
	.dl not_implemented ; 30 ;
	.dl not_implemented ; 31 ;
	.dl not_implemented ; 32 ;
	.dl not_implemented ; 33 ;
	.dl not_implemented ; 34 ;
	.dl not_implemented ; 35 ;
	.dl not_implemented ; 36 ;
	.dl not_implemented ; 37 ;
	.dl not_implemented ; 38 ;
	.dl not_implemented ; 39 ;
	.dl not_implemented ; 3A ;
	.dl not_implemented ; 3B ;
	.dl not_implemented ; 3C ;
	.dl not_implemented ; 3D ;
	.dl not_implemented ; 3E ;
	.dl program_end     ; 3F ; kOff
	.dl program_end     ; 40 ; kQuit
	.dl not_implemented ; 41 ;
	.dl not_implemented ; 42 ;
	.dl not_implemented ; 43 ;
	.dl not_implemented ; 44 ;
	.dl not_implemented ; 45 ;
	.dl not_implemented ; 46 ;
	.dl not_implemented ; 47 ;
	.dl not_implemented ; 48 ;
	.dl not_implemented ; 49 ;
	.dl not_implemented ; 4A ;
	.dl not_implemented ; 4B ;
	.dl not_implemented ; 4C ;
	.dl not_implemented ; 4D ;
	.dl not_implemented ; 4E ;
	.dl not_implemented ; 4F ;
	.dl not_implemented ; 50 ;
	.dl not_implemented ; 51 ;
	.dl not_implemented ; 52 ;
	.dl not_implemented ; 53 ;
	.dl not_implemented ; 54 ;
	.dl not_implemented ; 55 ;
	.dl not_implemented ; 56 ;
	.dl not_implemented ; 57 ;
	.dl not_implemented ; 58 ;
	.dl not_implemented ; 59 ;
	.dl not_implemented ; 5A ;
	.dl not_implemented ; 5B ;
	.dl not_implemented ; 5C ;
	.dl not_implemented ; 5D ;
	.dl not_implemented ; 5E ;
	.dl not_implemented ; 5F ;
	.dl not_implemented ; 60 ;
	.dl not_implemented ; 61 ;
	.dl not_implemented ; 62 ;
	.dl not_implemented ; 63 ;
	.dl not_implemented ; 64 ;
	.dl not_implemented ; 65 ;
	.dl not_implemented ; 66 ;
	.dl not_implemented ; 67 ;
	.dl not_implemented ; 68 ;
	.dl not_implemented ; 69 ;
	.dl not_implemented ; 6A ;
	.dl not_implemented ; 6B ;
	.dl not_implemented ; 6C ;
	.dl not_implemented ; 6D ;
	.dl not_implemented ; 6E ;
	.dl not_implemented ; 6F ;
	.dl not_implemented ; 70 ;
	.dl not_implemented ; 71 ;
	.dl not_implemented ; 72 ;
	.dl not_implemented ; 73 ;
	.dl not_implemented ; 74 ;
	.dl not_implemented ; 75 ;
	.dl not_implemented ; 76 ;
	.dl not_implemented ; 77 ;
	.dl not_implemented ; 78 ;
	.dl not_implemented ; 79 ;
	.dl not_implemented ; 7A ;
	.dl not_implemented ; 7B ;
	.dl not_implemented ; 7C ;
	.dl not_implemented ; 7D ;
	.dl not_implemented ; 7E ;
	.dl not_implemented ; 7F ;
	.dl add             ; 80 ; kAdd
	.dl subtract        ; 81 ; kSub
	.dl not_implemented ; 82 ; kMul
	.dl not_implemented ; 83 ; kDiv
	.dl not_implemented ; 84 ;
	.dl not_implemented ; 85 ;
	.dl not_implemented ; 86 ;
	.dl not_implemented ; 87 ;
	.dl not_implemented ; 88 ;
	.dl not_implemented ; 89 ;
	.dl not_implemented ; 8A ;
	.dl not_implemented ; 8B ;
	.dl not_implemented ; 8C ;
	.dl not_implemented ; 8D ;
	.dl numeric_entry   ; 8E ; k0
	.dl numeric_entry   ; 8F ; k1
	.dl numeric_entry   ; 90 ; k2
	.dl numeric_entry   ; 91 ; k3
	.dl numeric_entry   ; 92 ; k4
	.dl numeric_entry   ; 93 ; k5
	.dl numeric_entry   ; 94 ; k6
	.dl numeric_entry   ; 95 ; k7
	.dl numeric_entry   ; 96 ; k8
	.dl numeric_entry   ; 97 ; k9
	.dl not_implemented ; 98 ;
	.dl not_implemented ; 99 ;
	.dl not_implemented ; 9A ;
	.dl not_implemented ; 9B ;
	.dl not_implemented ; 9C ;
	.dl not_implemented ; 9D ;
	.dl not_implemented ; 9E ;
	.dl not_implemented ; 9F ;
	.dl not_implemented ; A0 ;
	.dl not_implemented ; A1 ;
	.dl not_implemented ; A2 ;
	.dl not_implemented ; A3 ;
	.dl not_implemented ; A4 ;
	.dl not_implemented ; A5 ;
	.dl not_implemented ; A6 ;
	.dl not_implemented ; A7 ;
	.dl not_implemented ; A8 ;
	.dl not_implemented ; A9 ;
	.dl not_implemented ; AA ;
	.dl not_implemented ; AB ;
	.dl not_implemented ; AC ;
	.dl not_implemented ; AD ;
	.dl not_implemented ; AE ;
	.dl not_implemented ; AF ;
	.dl not_implemented ; B0 ;
	.dl not_implemented ; B1 ;
	.dl not_implemented ; B2 ;
	.dl not_implemented ; B3 ;
	.dl not_implemented ; B4 ;
	.dl not_implemented ; B5 ;
	.dl not_implemented ; B6 ;
	.dl not_implemented ; B7 ;
	.dl not_implemented ; B8 ;
	.dl not_implemented ; B9 ;
	.dl not_implemented ; BA ;
	.dl not_implemented ; BB ;
	.dl not_implemented ; BC ;
	.dl not_implemented ; BD ;
	.dl not_implemented ; BE ;
	.dl not_implemented ; BF ;
	.dl not_implemented ; C0 ;
	.dl not_implemented ; C1 ;
	.dl not_implemented ; C2 ;
	.dl not_implemented ; C3 ;
	.dl not_implemented ; C4 ;
	.dl not_implemented ; C5 ;
	.dl not_implemented ; C6 ;
	.dl not_implemented ; C7 ;
	.dl not_implemented ; C8 ;
	.dl not_implemented ; C9 ;
	.dl not_implemented ; CA ;
	.dl not_implemented ; CB ;
	.dl not_implemented ; CC ;
	.dl not_implemented ; CD ;
	.dl not_implemented ; CE ;
	.dl not_implemented ; CF ;
	.dl not_implemented ; D0 ;
	.dl not_implemented ; D1 ;
	.dl not_implemented ; D2 ;
	.dl not_implemented ; D3 ;
	.dl not_implemented ; D4 ;
	.dl not_implemented ; D5 ;
	.dl not_implemented ; D6 ;
	.dl not_implemented ; D7 ;
	.dl not_implemented ; D8 ;
	.dl not_implemented ; D9 ;
	.dl not_implemented ; DA ;
	.dl not_implemented ; DB ;
	.dl not_implemented ; DC ;
	.dl not_implemented ; DD ;
	.dl not_implemented ; DE ;
	.dl not_implemented ; DF ;
	.dl not_implemented ; E0 ;
	.dl not_implemented ; E1 ;
	.dl not_implemented ; E2 ;
	.dl not_implemented ; E3 ;
	.dl not_implemented ; E4 ;
	.dl not_implemented ; E5 ;
	.dl not_implemented ; E6 ;
	.dl not_implemented ; E7 ;
	.dl not_implemented ; E8 ;
	.dl not_implemented ; E9 ;
	.dl not_implemented ; EA ;
	.dl not_implemented ; EB ;
	.dl not_implemented ; EC ;
	.dl not_implemented ; ED ;
	.dl not_implemented ; EE ;
	.dl not_implemented ; EF ;
	.dl not_implemented ; F0 ;
	.dl not_implemented ; F1 ;
	.dl not_implemented ; F2 ;
	.dl not_implemented ; F3 ;
	.dl not_implemented ; F4 ;
	.dl not_implemented ; F5 ;
	.dl not_implemented ; F6 ;
	.dl not_implemented ; F7 ;
	.dl not_implemented ; F8 ;
	.dl not_implemented ; F9 ;
	.dl not_implemented ; FA ;
	.dl not_implemented ; FB ;
	.dl not_implemented ; FC ;
	.dl not_implemented ; FD ;
	.dl not_implemented ; FE ;
	.dl not_implemented ; FF ;
