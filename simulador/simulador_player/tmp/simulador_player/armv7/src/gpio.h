// 'gpio.h' - GPIO model
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
// Authors : George Gondim Ribeiro, 03/10/2014
//
// ----------------------------------------------------------------------

#ifndef GPIO_H
#define GPIO_H

#include "peripheral.h"
#include "tzic.h"
#include <string>
#include <iostream>

#include <systemc.h>
#include <ac_tlm_protocol.H>
#include <gpio_map.h>

// More info about this module:
// Please refer to iMX53 Reference Manual page 1726


extern bool DEBUG_GPIO;

class gpio_module: public sc_module, public peripheral
{
private:
  
    static const unsigned GPIO_DR = 0x0; // GPIO data register
    static const unsigned GPIO_DIR = 0x4; // GPIO direction register
    static const unsigned GPIO_PSR = 0x8; // GPIO pad status register
    static const unsigned GPIO_ICR1 = 0xC; // GPIO interrupt configuration regoister 1
    static const unsigned GPIO_ICR2 = 0x10; // GPIO interrupt configuration register 2
    static const unsigned GPIO_IMR = 0x14; // GPIO interrupt mask register
    static const unsigned GPIO_ISR = 0x18; // GPIO interrupt  status register
    static const unsigned GPIO_EDGE_SEL = 0x1C; // GPIO edge selection
    static const unsigned GPIO_LASTADDR = 0x28;
  
    // According to IMX53 SoC
   
    static const unsigned short GPIO_INT0=49;
    static const unsigned short GPIO_INT1=48;
    static const unsigned short GPIO_INT2=47;
    static const unsigned short GPIO_INT3=46;
    static const unsigned short GPIO_INT4=45;
    static const unsigned short GPIO_INT5=44;
    static const unsigned short GPIO_INT6=43;
    static const unsigned short GPIO_INT7=42;
    static const unsigned short GPIO_INT0_15=50;
    static const unsigned short GPIO_INT16_31=51;
     
    unsigned regs[GPIO_LASTADDR / 4];

    enum selected_clock_t
    { CLK_OFF = 0, PERIPHERAL_CLK = 1, HI_FREQ = 2, EXTERNAL_CLK = 3,
      LOW_FREQ = 4
    };
  

    selected_clock_t clock_src;
    bool enabled;
    std::string gpio_past_bstr;
  
    void do_reset(bool hard_reset = true)
    {
        gpio_past_bstr = std::string(32, '0');
        enabled = true;
        clock_src = PERIPHERAL_CLK;
        *(regs + GPIO_DR / 4) = 0;
        *(regs + GPIO_DIR / 4) = 0;
        *(regs + GPIO_PSR / 4) = 0;
        *(regs + GPIO_ICR1 / 4) = 0;
        *(regs + GPIO_ICR2 / 4) = 0;
        *(regs + GPIO_IMR / 4) = 0;
        *(regs + GPIO_ISR / 4) = 0;
        *(regs + GPIO_EDGE_SEL / 4) = 0;
        for (int gpio_irq_num = 42; gpio_irq_num < 52; gpio_irq_num++)
        {
            tzic.interrupt (gpio_irq_num, true);
        }
    }

    // This port is used to send interrupts to the processor
    tzic_module & tzic;
    GPIO_map *gm ;
  
    // Fast read/write don't implement error checking. The bus (or other caller)
    // must ensure the address is valid.
    // Invalid read/writes are treated as no-ops.
    // Unaligned addresses have undefined behavior
    unsigned fast_read (unsigned address);
    void fast_write (unsigned address, unsigned datum);
    unsigned read_pads(GPIO_map **gm);
    void write_pads(GPIO_map **gm, unsigned datum);
  
  
public:
  
    //Wrappers to call fast_read/write with correct parameters
    unsigned read_signal (unsigned address, unsigned offset);
  
    void write_signal (unsigned address, unsigned datum, unsigned offset);


    // This is the main process to simulate the IP behavior
    void prc_gpio ();
  
    SC_HAS_PROCESS (gpio_module); 
  
    gpio_module (sc_module_name name_, tzic_module & tzic_):
        sc_module (name_), tzic (tzic_)
    {
    
        // A SystemC thread never finishes execution, but transfers control back
        // to SystemC kernel via wait() calls.
 
        SC_THREAD (prc_gpio);
        do_reset ();
        gm = new GPIO_map(DEBUG_GPIO);
        gm->gpio_connect();
    }
  
};


#endif
