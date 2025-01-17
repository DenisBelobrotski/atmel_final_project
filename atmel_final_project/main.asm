.def temp_0 = r16
.def switcher = r17
.def mutex = r18

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

cbi DDRC, 5
sbi PORTC, 5

cbi DDRC, 6
sbi PORTC, 6

cbi DDRC, 7
sbi PORTC, 7

ldi switcher, 0b00000000
ldi mutex, 0

sei

end: rjmp end



next_data:

// check btn_5 end
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


// check btn_6 end
sbrs switcher, 6
rjmp skip_btn_6_end_check

cpi ZH, high(end_btn_6_txt * 2)
brne skip_btn_6_end_check
cpi ZL, low(end_btn_6_txt * 2)
brne skip_btn_6_end_check

ldi mutex, 0
ldi temp_0, 0b10111111
and switcher, temp_0

skip_btn_6_end_check:


// check btn_7 end
sbrs switcher, 7
rjmp skip_btn_7_end_check

cpi ZH, high(end_btn_7_txt * 2)
brne skip_btn_7_end_check
cpi ZL, low(end_btn_7_txt * 2)
brne skip_btn_7_end_check

ldi mutex, 0
ldi temp_0, 0b01111111
and switcher, temp_0

skip_btn_7_end_check:


cpi switcher, 0b00000000
breq skip_out
// write next data
lpm temp_0, Z+
out UDR, temp_0
skip_out:


// check mutex
cpi mutex, 0
brne end_data


// check buttons
cpi switcher, 0b00000000
brne skip_buttons_check

// check btn 5 click
sbic PINC, 5
rjmp skip_5_click
	ldi temp_0, 0b00100000
	or switcher, temp_0
skip_5_click:

// check btn 6 click
sbic PINC, 6
rjmp skip_6_click
	ldi temp_0, 0b01000000
	or switcher, temp_0
skip_6_click:

// check btn 7 click
sbic PINC, 7
rjmp skip_7_click
	ldi temp_0, 0b10000000
	or switcher, temp_0
skip_7_click:

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


// check button 6 data start
ldi temp_0, 0b01000000
and temp_0, switcher
cpi temp_0, 0b01000000
brne skip_button_6_check

ldi ZH, high(btn_6_txt * 2)
ldi ZL, low(btn_6_txt * 2)

ldi mutex, 1
rjmp end_data

skip_button_6_check:


// check button 7 data start
ldi temp_0, 0b10000000
and temp_0, switcher
cpi temp_0, 0b10000000
brne skip_button_7_check

ldi ZH, high(btn_7_txt * 2)
ldi ZL, low(btn_7_txt * 2)

ldi mutex, 1
rjmp end_data

skip_button_7_check:

end_data: 
reti

btn_5_txt:
.db "-btn5-"
end_btn_5_txt:

btn_6_txt:
.db "-btn6-"
end_btn_6_txt:

btn_7_txt:
.db "-btn7-"
end_btn_7_txt:
