#ifndef _CLASS_PWMCONTROL_H_
#define _CLASS_PWMCONTROL_H_




#include "motor.h"
#include "robots.h"
#include <bitset>
#include <string>  
#include <thread>
#include <unistd.h>


#define BOOST_SIGNALS_NO_DEPRECATION_WARNING

#include <libplayerc++/playerc++.h>


using namespace PlayerCc;







class PWMcontrol {

friend class Robot;

public:
    
    PWMcontrol(PlayerClient *, unsigned short = 0);
    ~PWMcontrol();


    

private:    
    Motors * motors;


    std::thread *reader;

    std::bitset<Pioneer3dx::DAC_WIDTH> DB0;
    std::bitset<1> WR0;

    std::bitset<Pioneer3dx::DAC_WIDTH> DB1;
    std::bitset<1> WR1;

    void read();
};


#endif // _CLASS_PWMCONTROL_H

