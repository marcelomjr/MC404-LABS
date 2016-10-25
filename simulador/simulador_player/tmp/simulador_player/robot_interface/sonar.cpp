#include "sonar.h"

Sonar::Sonar(PlayerClient *robot, unsigned short index)
{
       this->sonar = new RangerProxy(robot,index);     
}



double Sonar::getDistancia(int n)
{
    if ( this->done() )
    {
        return this->sonar->GetRange(n);
    }
    else
    {
        return (-1.0);
    }
}


bool Sonar::done()
{    
    if ( this->sonar->GetRangeCount() > 0 )
    {
        return true;
    }
    else
    {
        return false;
    }
}


int Sonar::quantSonares()
{
    return this->sonar->GetRangeCount();
}


Sonar::~Sonar()
{
    delete this->sonar;
}
