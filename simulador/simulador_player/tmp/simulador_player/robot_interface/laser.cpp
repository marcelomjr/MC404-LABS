#include "laser.h"

Laser::Laser(PlayerClient *robot, unsigned short index)
{
    this->laser = new RangerProxy(robot,index);    
}


double Laser::getDistancia(int ang)
{
    if ( this->done() )
    {
        return this->laser->GetRange(ang);
    }
    else
    {
        return (-1.0);
    }
}


bool Laser::done()
{
    if ( this->laser->GetRangeCount() > 0 )
    {
        return true;
    }
    else
    {
        return false;
    }
}


int Laser::quantAngulos()
{
    return this->laser->GetRangeCount();
}


Laser::~Laser()
{
    delete this->laser;
}
