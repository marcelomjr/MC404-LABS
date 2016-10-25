// 'gpio.cpp' - GPIO model
//
// Copyright (C) 2014 The ArchC team.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ----------------------------------------------------------------------
// This represents the UART used in the ARM SoC by Freescale iMX35.
//
// Author : George Gondim Ribeiro, 03/10/2014
//
// ----------------------------------------------------------------------

#include "gpio.h"
#include "arm_interrupts.h"
#include <stdarg.h>

extern bool DEBUG_GPIO;

#define RW_DELAY 50


static inline int
dprintf(const char *format, ...)
{
    int ret;

    if (DEBUG_GPIO)
    {
        va_list args;
        va_start (args, format);
        ret = vfprintf(ac_err, format, args);
        va_end (args);
    }
    return ret;
}

void
gpio_module::write_pads(GPIO_map **gm, unsigned datum)
{
    std::string gpio_bstr;
    (*gm)->gpio_read(&gpio_bstr);
    GPIO_map::delay_ms(RW_DELAY); // modificado para teste

    unsigned mask = 1;
    for (int i = 31; i >=0; i--)
    {
        if ( (*(regs + GPIO_DIR / 4) & (mask << i)) != 0 )
        {
            gpio_bstr[GPIO_map::POS(i)] = ( (datum & (mask << i)) > 0 ) ? '1' : '0';
        } 
    }

    (*gm)->gpio_write(gpio_bstr);      
}

unsigned
gpio_module::read_pads(GPIO_map **gm)
{
    std::string gpio_bstr;
    unsigned res;

    (*gm)->gpio_read(&gpio_bstr);
    GPIO_map::delay_ms(RW_DELAY); // modificado para test

    res = 0;
    for (int i = 31; i >= 0; i--)
    {
        res = (res << 1) | (gpio_bstr[GPIO_map::POS(i)] - '0') ; 
    }

    return res;
}

unsigned
gpio_module::fast_read(unsigned address)
{
    unsigned res = 0;
  
    switch (address)
    {
    case GPIO_DR: 
        *(regs + GPIO_PSR / 4) = read_pads(&gm);
        res = (*(regs + GPIO_DR / 4) & *(regs + GPIO_DIR / 4)) |
            (*(regs + GPIO_PSR / 4) & ~(*(regs + GPIO_DIR / 4)));  
        break;
    default:
        res =  *(regs + address / 4);
        break;    
    }

    dprintf("READ ADDRESS 0x%X | Value: 0x%X\n", address, res);
    return res;
}

void
gpio_module::fast_write(unsigned address, unsigned datum)
{
    switch (address)
    {
        // Read-only registers
    case GPIO_PSR:
        break;
        
        // Write allowed registers        
    case GPIO_ISR:
        // std::cout << "Register ISR" << std::endl;
        // std::cout << "\tbefore:" << std::hex << *(regs + address / 4) << std::endl;
        *(regs + address / 4) &= (~datum);
        // std::cout << "\tafter:" << std::hex << *(regs + address / 4) << std::endl;
        break;
        
    case GPIO_DR:
        write_pads(&gm, datum);
        
    case GPIO_DIR:              
    case GPIO_ICR1:   
    case GPIO_ICR2:   
    case GPIO_IMR:   
    case GPIO_EDGE_SEL:

        if (address == GPIO_IMR || address == GPIO_ICR1) {
            // std::cout << "Register 0x"  << std::hex << address<< std::endl;
            // std::cout << "\tbefore:" << std::hex << *(regs + address / 4) << std::endl;
        }
        
        *(regs + address / 4) = datum;

        if (address == GPIO_IMR || address == GPIO_ICR1) {
            
            // std::cout << "\tafter:" << std::hex << *(regs + address / 4) << std::endl;
        }
        
        break;
        
    default:
        break;
    }

    dprintf("WRITE ADDRESS 0x%X | Value: 0x%X\n", address, datum);


}



unsigned 
gpio_module::read_signal (unsigned address, unsigned offset)
{
    return fast_read (address);
}

void 
gpio_module::write_signal (unsigned address, unsigned datum, 
                           unsigned offset)
{
    fast_write (address, datum);
}

void 
gpio_module::prc_gpio ()
{
    std::string gpio_bstr;
    unsigned mask_icr, mask_imr;

    char o = '0', n;

    do
    {
        wait (1, SC_NS);

        if (!enabled)
            continue;

        if (clock_src == CLK_OFF | clock_src == EXTERNAL_CLK)
            continue;

        dprintf ("-------------------- GPIO --------------------- \n");
        dprintf ("Data register: 0x%X\n", *(regs + GPIO_DR / 4));
        dprintf ("Direction register: 0x%X\n", *(regs + GPIO_DIR / 4));
        dprintf ("Pad status register:: 0x%X\n", *(regs + GPIO_PSR / 4));

        // Verify changes in GPIO's input (GPIO_PSR)
        gm->gpio_read(&gpio_bstr);
        
        n = gpio_bstr[GPIO_map::POS(0)];
        if ( o != n )
        {
            // std::cout << "READY: " << n << std::endl;
            o = n;
        }
        
        // Generate interrupts    
        // lines 0 to 7
        mask_icr = 0x3;
        mask_imr = 0x1;
        bool gen_interrupt;
        for ( unsigned short gpio_irq_num = GPIO_INT0,  intnumber = 0;
              gpio_irq_num >= GPIO_INT7;
              gpio_irq_num--, intnumber++ )
        {
            gen_interrupt = false;
            if ((*(regs + GPIO_IMR / 4) & mask_imr) == mask_imr)
            {
                if ((*(regs + GPIO_ISR / 4) & mask_imr) == 0)
                {
                    short type = (*(regs + GPIO_ICR1 / 4) >> 2*intnumber) & mask_icr;
                    char currbit = gpio_bstr[GPIO_map::POS(intnumber)];
                    char pastbit = gpio_past_bstr[GPIO_map::POS(intnumber)];

                    // std::cout << "type: " << type << std::endl;
                    // std::cout << "currbit: " << currbit << std::endl;
                    // std::cout << "pastbit: " << pastbit << std::endl;
                    // GPIO_map::delay_ms(5);
                        
                    if (
                        (type == 0 && currbit == '0') ||
                        (type == 1 && currbit == '1') ||
                        (type == 2 && pastbit == '0' && currbit == '1') ||
                        (type == 3 && pastbit == '1' && currbit == '0')
                        )
                    {
                    
                        *(regs + GPIO_ISR / 4) |= mask_imr;
                        // std::cout << "ISR: " << *(regs + GPIO_ISR / 4) << " asserted" << std::endl;
                        // std::cout << "IRQ: " << std::dec << gpio_irq_num << " asserted" << std::endl;
                        dprintf("Asserted interrupt line in TZIC. IRQNUM %d\n", gpio_irq_num);
                        gen_interrupt = true;
                    }
                }
                // else
                // {
                //     std::cout << "ISR: " << *(regs + GPIO_ISR / 4) << " asserted" << std::endl;
                //     std::cout << "IRQ: " << std::dec << gpio_irq_num << " asserted" << std::endl;
                //     gen_interrupt = true;
                // }
            }

            if (gen_interrupt)
            { 
                tzic.interrupt (gpio_irq_num, false);
            }
            else
            {
                tzic.interrupt (gpio_irq_num, true);
            }
            
            mask_imr = mask_imr << 1;
        }

        // set INT0_15 and int16_31

        gpio_past_bstr = gpio_bstr;
    } while (1);
}
