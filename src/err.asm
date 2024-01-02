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

#define not_implemented_err 1
not_implemented_str:
	.db "Not implemented", 0

#define divide_by_zero_err 2
divide_by_zero_str:
	.db "Divide by zero", 0

err_table:
	.dl not_implemented_str ; 0
	.dl not_implemented_str ; 1
	.dl divide_by_zero_str  ; 2
