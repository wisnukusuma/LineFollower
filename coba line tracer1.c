/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 16/06/2016
Author  : FUDOMAS
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 11,059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#define maju_kanan   PORTD.7
#define maju_kiri    PORTD.3
#define mundur_kanan PORTD.6
#define mundur_kiri  PORTD.2
#define kec_kiri     OCR1B  
#define kec_kanan    OCR1A
char sensor[16];
int posisi;
 
unsigned char sen[10], garis;
int i;
int adc[10],logic[10];
int limit_adc=50;
char s[8];
char datagelap[8],dataterang[8],range[8],hasilbin[8];
char tampil[33];

// Alphanumeric LCD functions
#include <alcd.h>

#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

void maju()
{
    maju_kanan=1;
    mundur_kanan=0;
    maju_kiri=0;
    mundur_kiri=1;
        
}
void mundur()
{
    maju_kanan=0;
    mundur_kanan=1;
    maju_kiri=1;
    mundur_kiri=0;
        
}

void belok_kanan()
{
    maju_kanan=0;
    mundur_kanan=1;
    maju_kiri=0;
    mundur_kiri=1;    
}

void belok_kiri()
{
    maju_kanan=1;
    mundur_kanan=0;
    maju_kiri=1;
    mundur_kiri=0;    
}




void bacasensor()
         {        
           
    
          
         s[0]=read_adc(0);
      s[1]=read_adc(1);
      s[2]=read_adc(2);
      s[3]=read_adc(3);
      s[4]=read_adc(4);
      s[5]=read_adc(5);
      s[6]=read_adc(6);                                                        
      s[7]=read_adc(7);
      i=0;
      while(i<8)
      {
      if(s[i]>datagelap[i]) datagelap[i]=s[i];         
      else if(s[0]<dataterang[0]) dataterang[i]=s[i]; 
      
      range[i]=((datagelap[i]-dataterang[i])/2)+dataterang[i];
      
      if(s[i]<range[i]) hasilbin[i]=0;
      else hasilbin[i]=1;
      i++;}
      
      lcd_gotoxy(4,0);
      sprintf(tampil,"%d%d%d%d%d%d%d%d",hasilbin[0],hasilbin[1],hasilbin[2],hasilbin[3],hasilbin[3],hasilbin[4],hasilbin[5],hasilbin[6],hasilbin[7]);
      lcd_puts(tampil);
          
          // untuk mengubah menjadi logic high atau low tinggal
          // kita buat limitnya      
      
          }
 
void logika()
{                       
        garis=(hasilbin[7]*128)+(hasilbin[6]*64)+(hasilbin[5]*32)+(hasilbin[4]*16)+(hasilbin[3]*8)+(hasilbin[2]*4)+(hasilbin[1]*2)+(hasilbin[0]*1);
} 



  
      
    
   




// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 10,800 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691,200 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 16
lcd_init(16);


          
      
          
while (1)
      {        
            
            logika();
           
            bacasensor();
            
            switch(garis)      
            { 
            case 0b01111111:
            {
            
            belok_kanan();
            kec_kiri=70;
            kec_kanan=70;}
            break; 
               
            case 0b00111111:
            {
            
            belok_kanan();
            kec_kiri=70;
            kec_kanan=70;}
            break;    
            
            case 0b00011111:
            {
            belok_kanan();
            kec_kiri=70;
            kec_kanan=70;}
            break;
            
            case 0b00001111:
            {
            belok_kanan();
            kec_kiri=70;
            kec_kanan=70;}
            break;
            
            case 0b00000111:
            {posisi=-9;
            belok_kanan();
            kec_kiri=70;
            kec_kanan=70;}
            break;
                            
            case 0b00000001:
            {posisi=-9;
            belok_kanan();
            kec_kiri=130;
            kec_kanan=50;}
            break;
            
            case 0b00000011:
            {posisi=-9;
            maju();
            kec_kiri=120;
            kec_kanan=50;}
            break;  
            
            case 0b00000010:
            { posisi=-9;
            kec_kiri=150;
            kec_kanan=45;}
            break;
            
            case 0b00000110:
            {posisi=-9;
            kec_kiri=140;
            kec_kanan=60;}
            break;  
            
            case 0b00000100:
            {posisi=-9;
            maju();
            kec_kiri=140;
            kec_kanan=60;}
            break;
            
            case 0b00001100:
            {posisi=-9;
            maju();
            kec_kiri=150;
            kec_kanan=100;}
            break;  
            
            case 0b00001000:
            {
            maju();
            kec_kiri=150;
            kec_kanan=100;}
            break;  
            
            case 0b00011000:
            {maju();
            kec_kiri=150;
            kec_kanan=150;}
            break;  //kondisi tengah
            
            case 0b00010000:
            {
            maju();
            kec_kiri=100;
            kec_kanan=150;}
            break;
            
            case 0b00110000:
            {
            maju();
            kec_kiri=50;
            kec_kanan=100;}
            break;   
            
            case 0b00100000:
            {posisi=9;
            maju();
            kec_kiri=60;
            kec_kanan=130;}
            break;
            
            case 0b01100000:
            {posisi=9;
            maju();
            kec_kiri=60;
            kec_kanan=150;
            }
            break;   
            
            case 0b01000000:
            {posisi=9;
            maju();
            kec_kiri=60;
            kec_kanan=140;
            }
            break;
            
            case 0b11000000:
            {posisi=9;
            maju();
            kec_kiri=40;
            kec_kanan=100;
            }
            break;
            
            case 0b10000000:
            {posisi=9;
            belok_kiri();
            kec_kiri=40;
            kec_kanan=100;
            }
            break;
            
            case 0b11100000:
            {posisi=9;
            belok_kiri();
            kec_kiri=70;
            kec_kanan=70;
            }
            break;
            
            case 0b11110000:
            {posisi=9;
            belok_kiri();
            kec_kiri=70;
            kec_kanan=70;            
            }break;
            
            case 0b11111000:
            {belok_kiri();
            kec_kiri=70;
            kec_kanan=70;
            }
            break;
            
            case 0b11111100:
            {belok_kiri();
            kec_kiri=70;
            kec_kanan=70;
            }
            break;
            
            case 0b11111110:
            {belok_kiri();
            kec_kiri=70;
            kec_kanan=70;
            }
            break;
            
            case 0b00000000: 
            {if(posisi<0)
            {
            belok_kanan();
            kec_kiri=70;
            kec_kanan=70;
            }
            else if(posisi>0)
            {belok_kiri();
            kec_kiri=70;
            kec_kanan=70;}
            
            }
            break;
            
            case 0b11111111:
            {                                                                          
            mundur();
            kec_kiri=100;
            kec_kanan=100;
            break;}
            
            case 0b00111100:
            {maju();
            kec_kiri=150;
            kec_kanan=150;
            }
            break; 
            
            case 0b01111000:
            {belok_kanan();
            kec_kiri=140;
            kec_kanan=100;
            }
            break;
            
           
         } 
            
         }
         }