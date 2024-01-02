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

T_display_buffer:
	.db $00, $00, $00, $00, $00, $00, $00, $00
Z_display_buffer:
	.db $00, $00, $00, $00, $00, $00, $00, $00
Y_display_buffer:
	.db $00, $00, $00, $00, $00, $00, $00, $00
X_display_buffer:
	.db $00, $00, $00, $00, $00, $00, $00, $00

init_disp:
refresh_disp:
	call	_homeup
	call	_ClrScrnFull
	ld	hl, (T)
	call	_DispHL
	call	_NewLine
	ld	hl, (Z)
	call	_DispHL
	call	_NewLine
	ld	hl, (Y)
	call	_DispHL
	call	_NewLine
	ld	hl, (X)
	call	_DispHL
	call	_NewLine

	; check for errors
	ld	a, (err)
	cp	0
	call	nz, disp_err
	ret

disp_X:

; input: a
; destroys: all
disp_err:
	; load A into HL and multiply by 3
	ld	hl, 0
	ld	l, a
	ld	de, 0
	ld	e, a
	add	hl, hl
	add	hl, de
	; add base address
	ld	de, err_table
	add	hl, de
	; load address from table
	ld	hl, (hl)
	; display error string
	push	hl
	call	_NewLine
	pop	hl
	call	_PutS
	; reset err
	xor	a
	ld	(err), a
	ret
