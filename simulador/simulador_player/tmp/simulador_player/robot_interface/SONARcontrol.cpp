#include "SONARcontrol.h"

SONARcontrol::SONARcontrol(PlayerClient * rb, unsigned short index)
{
    this->sonars = new Sonar(rb, index);
    this->data.reset();
    this->selectSonar.reset();

    this->done.reset();
    this->trigger.reset();
}



void SONARcontrol::setTrigger(const char t)
{
    (this->trigger == '0') ? this->lastTrigger.reset() 
                           : this->lastTrigger.set();
    (t == '0') ? this->trigger.reset() : this->trigger.set();

    if (( this->lastTrigger.to_string() == "1" ) 
        && (this->trigger.to_string() == "0"))
    {
        int sn = this->selectSonar.to_ulong(); 
        double dist = this->sonars->getDistancia(sn);


        sn = (Pioneer3dx::COUNTER_MAX*dist)/ Pioneer3dx::SONAR_MAX_DIST;
        int bp = 1;
        for(int i = 0; i < Pioneer3dx::B_COUNTER_WIDTH; i++)
        { 
            ((bp & sn) == bp) ? this->data.set(i) : this->data.reset(i);
            bp = bp << 1;  
        }
        this->done.set();

    }
    else if (this->trigger.to_string() == "1")
    {
        this->data.reset();
        this->done.reset();
    }
    else
    {
        this->done.reset();
    }
    
}


SONARcontrol::~SONARcontrol()
{
    delete this->sonars;
}
