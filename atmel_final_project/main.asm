.org 0
jmp reset
.org 0x1C
jmp nextData

reset:

ldi r16,high(RAMEND)
out SPH,r16
ldi r16,low(RAMEND)
out SPL,r16

ldi r16,0
out UBRRH,r16
ldi r16,51
out UBRRL,r16

ldi r16,(1<<UDRIE)|(1<<TXEN)//|(1<<RXEN)
out UCSRB,r16

ldi ZH,high(none_txt*2)
ldi ZL,low(none_txt*2)
lpm r16,Z+
out UDR,r16

sei

end: rjmp end

nextData:
lpm r16,Z+
out UDR,r16

cpi ZH,high(end_none_txt*2)
brne endData
cpi ZL,low(end_none_txt*2)
brne endData

ldi ZH,high(none_txt*2)
ldi ZL,low(none_txt*2)

endData: reti

none_txt:
.db "-none-"
end_none_txt:
