#include "PWMcontrol.h"

PWMcontrol::PWMcontrol(PlayerClient *rb, unsigned short index)
{
    this->motors = new Motors(rb, index);
    this->DB0.reset();
    this->WR0.reset();

    this->DB1.reset();
    this->WR1.reset();
    this->reader = new std::thread(&PWMcontrol::read, this); 

}



void PWMcontrol::read()
{
    for(;;)
    {
        if ( this->WR0.to_string() == "0" )
        {
            this->motors->setSpeed_m0( Pioneer3dx::MAX_SPEED * 
                   ( this->DB0.to_ulong()/Pioneer3dx::DAC_MAX_N ) );
        }
        
        if ( this->WR1.to_string() == "0" )
        {
            this->motors->setSpeed_m1( Pioneer3dx::MAX_SPEED * 
                   ( this->DB1.to_ulong()/Pioneer3dx::DAC_MAX_N ) );            
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(20));
    }
}



PWMcontrol::~PWMcontrol()
{
    delete this->motors;
}
