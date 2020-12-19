.def temp_0 = r16

.org 0
jmp reset
.org 0x1C
jmp nextData

reset:

ldi temp_0, high(RAMEND)
out SPH, temp_0
ldi temp_0, low(RAMEND)
out SPL, temp_0

ldi temp_0, 0
out UBRRH, temp_0
ldi temp_0, 51
out UBRRL, temp_0

ldi temp_0, (1<<UDRIE)|(1<<TXEN)
out UCSRB, temp_0

ldi ZH, high(none_txt*2)
ldi ZL, low(none_txt*2)
lpm temp_0, Z+
out UDR, temp_0

sei

end: rjmp end

nextData:
lpm temp_0, Z+
out UDR, temp_0

cpi ZH, high(end_none_txt*2)
brne endData
cpi ZL, low(end_none_txt*2)
brne endData

ldi ZH, high(none_txt*2)
ldi ZL, low(none_txt*2)

endData: reti

none_txt:
.db "-none-"
end_none_txt:
