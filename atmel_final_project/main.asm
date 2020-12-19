.def temp_0 = r16
.def switcher = r17
.def mutex = r18
.def temp_1 = r19

.org 0
jmp reset
.org 0x1C
jmp next_data

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

ldi ZH, high(none_txt * 2)
ldi ZL, low(none_txt * 2)
lpm temp_0, Z+
out UDR, temp_0

cbi DDRC, 5
sbi PORTC, 5

ldi switcher, 0b00000000
ldi mutex, 1

sei

end: rjmp end



next_data:


// write next data
lpm temp_0, Z+
out UDR, temp_0


// check none end
cpi switcher, 0b00000000
brne skip_none_end_check

cpi ZH, high(end_none_txt * 2)
brne skip_none_end_check
cpi ZL, low(end_none_txt * 2)
brne skip_none_end_check

ldi mutex, 0

skip_none_end_check:


// check btn_1 end
sbrs switcher, 5
rjmp skip_btn_5_end_check

cpi ZH, high(end_btn_5_txt * 2)
brne skip_btn_5_end_check
cpi ZL, low(end_btn_5_txt * 2)
brne skip_btn_5_end_check

ldi mutex, 0
ldi temp_0, 0b11011111
and switcher, temp_0

skip_btn_5_end_check:


// check mutex
cpi mutex, 0
brne end_data

cpi switcher, 0b00000000
brne skip_buttons_check

// check buttons
// ldi switcher, 0b11100000
ldi switcher, 0b00100000
in temp_0, PINC
and switcher, temp_0

skip_buttons_check:


// check button 5 data start
ldi temp_0, 0b00100000
and temp_0, switcher
cpi temp_0, 0b00100000
brne skip_button_5_check

ldi ZH, high(btn_5_txt * 2)
ldi ZL, low(btn_5_txt * 2)

ldi mutex, 1
rjmp end_data

skip_button_5_check:


// no buttons clicked
ldi ZH, high(none_txt * 2)
ldi ZL, low(none_txt * 2)
ldi mutex, 1
rjmp end_data

end_data: 
reti

none_txt:
.db "-none-"
end_none_txt:

btn_5_txt:
.db "-btn5-"
end_btn_5_txt:
