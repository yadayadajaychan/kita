.PHONY: all
all: kita.8xp

kita.8xp: src/kita.asm src/disp.asm src/err.asm src/func.asm src/menu.asm
	spasm -E -T src/kita.asm kita.8xp

.PHONY: clean
clean:
	-rm kita.8xp kita.lst
