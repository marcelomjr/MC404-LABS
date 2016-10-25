#ifndef _ROBOTS_H
#define _ROBOTS_H

namespace Pioneer3dx 
{
     static const double D = 0.38;  // pioneer 3-DX 
     static const double MAX_SPEED = 1.0;  // pioneer 3-DX (m/s)    
     static const unsigned char DAC_WIDTH = 6;
     static const unsigned char DAC_Vref = 4; // 4 volts
     static const double DAC_MAX_N = 63.0;

     static const unsigned char B_COUNTER_WIDTH = 12;
     static const unsigned char MUX_SELECT = 4;
     static const int COUNTER_MAX = 4095;



     static const int SONAR_MAX_DIST = 5; // 5m
     

};

#endif


// LMS200 Laser
