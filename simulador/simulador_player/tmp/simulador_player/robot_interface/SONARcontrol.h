#ifndef _CLASS_SONARCONTROL_H_
#define _CLASS_SONARCONTROL_H_

// Vref DAC = 4V


#include "sonar.h"
#include "robots.h"
#include <bitset>
#include <string>  
#include <thread>

#define BOOST_SIGNALS_NO_DEPRECATION_WARNING

#include <libplayerc++/playerc++.h>


using namespace PlayerCc;




class SONARcontrol {

friend class Robot;

public:
    
    SONARcontrol(PlayerClient *, unsigned short = 0);
    ~SONARcontrol();


    void setTrigger(const char);


    

private:    
    Sonar * sonars;



    std::bitset<Pioneer3dx::B_COUNTER_WIDTH> data;
    std::bitset<Pioneer3dx::MUX_SELECT>  selectSonar;    
    std::bitset<1>  done;

    std::bitset<1>  trigger;

    std::bitset<1>  lastTrigger;

    

};


#endif // _CLASS_SONARCONTROL_H

