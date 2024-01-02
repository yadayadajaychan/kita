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

#include "inc/ti84pce.inc"
.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

program_start:
	ld	(save_sp), sp
	call	init_disp

main_loop:
	call	_GetKey
	call	choose_func
	call	refresh_disp
	jr	main_loop

program_end:
	ld	sp, (save_sp)
	call	_ClrScrnFull
	res	donePrgm, (iy+doneFlags)
	ret

; choose_func chooses which function to jump to
; by looking up value of A in func_table
; destroys: HL, DE
choose_func:
	; load A into HL and multiply by 3
	ld	hl, 0
	ld	l, a
	ld	de, 0
	ld	e, a
	add	hl, hl
	add	hl, de
	; add base address
	ld	de, func_table
	add	hl, de
	; load address and jump
	ld	hl, (hl)
	jp	(hl)

numeric_entry:
	ld	hl, 0
	ld	l, a
	push	hl ; save a
	ld	a, (state)
	bit	stack_lift_state, a
	jr	z, numeric_entry_no_stack_lift
	call	lift_stack
numeric_entry_no_stack_lift:
	call	clear_X
	pop	hl
	ld	a, l
	sub	a, $8E
	ld	(X), a
numeric_entry_loop:
	call	refresh_disp
	call	_GetKey
	cp	$0A ; del key
	jr	z, backspace
	cp	$8E
	jp	c, choose_func ; A < k0
	cp	$98
	jp	nc, choose_func ; A > k9
	; number processing
	sub	a, $8E
	; TODO check number against base
	; TODO assume base 10 for now
	; multiply X by base and add number
	ld	hl, (X)
	add	hl, hl
	push	hl
	pop	de
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	de, 0
	ld	e, a
	add	hl, de
	ld	(X), hl
	jr	numeric_entry_loop
backspace:
	; backspace
	jr	numeric_entry_loop


#include "src/disp.asm"
#include "src/menu.asm"
#include "src/func.asm"
#include "src/err.asm"

save_sp:
	.dl 0

; Registers
T:
	.db $00, $00, $00, $00, $00, $00, $00, $00
Z:
	.db $00, $00, $00, $00, $00, $00, $00, $00
Y:
	.db $00, $00, $00, $00, $00, $00, $00, $00
X:
	.db $00, $00, $00, $00, $00, $00, $00, $00
last_X:
	.db $00, $00, $00, $00, $00, $00, $00, $00
tmp:
	.db $00, $00, $00, $00, $00, $00, $00, $00
	.db $00, $00, $00, $00, $00, $00, $00, $00 ; extra space for divisions
state:
#define stack_lift_state 7
#define leading_zeroes_state 6
#define G_flag_state 5
#define C_flag_state 4
; base - 1 bits 0-3
	.db $09

; complement bits 6-7
; wsize - 1 bits 0-5
	.db $3F

; window bits 0-2
	.db $00

err:
	.db $00

enable_stack_lift:
	ld	a, (state)
	set	stack_lift_state, a
	ld	(state), a
	ret

disable_stack_lift:
	ld	a, (state)
	res	stack_lift_state, a
	ld	(state), a
	ret

set_C_flag:
	ld	a, (state)
	set	C_flag_state, a
	ld	(state), a
	ret

reset_C_flag:
	ld	a, (state)
	res	C_flag_state, a
	ld	(state), a
	ret

set_G_flag:
	ld	a, (state)
	set	G_flag_state, a
	ld	(state), a
	ret

reset_G_flag:
	ld	a, (state)
	res	G_flag_state, a
	ld	(state), a
	ret

; loads base into A
get_base:
	ld	a, (state)
	and	$0F
	inc	a
	ret

.end
