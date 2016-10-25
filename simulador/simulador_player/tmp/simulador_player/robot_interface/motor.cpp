#include "motor.h"

Motors::Motors(PlayerClient *robot, unsigned short index)
{
    motor = new Position2dProxy(robot,index);
    this->refreshSettings();
    this->speed_m0 = this->speed_m1 = 0.0;
}


void Motors::setSpeed_m0(double speed)
{
    this->speed_m0 = speed;
    this->refreshSettings();
}


void Motors::setSpeed_m1(double speed)
{
    this->speed_m1 = speed;
    this->refreshSettings();
}


void Motors::setSpeeds(double speed0, double speed1)
{
    this->speed_m0 = speed0;
    this->speed_m1 = speed1;
    this->refreshSettings();
}


void Motors::refreshSettings()
{
    this->speed    = (this->speed_m0 + this->speed_m1) / 2.0; // linear
    this->turnrate = (this->speed_m0 - this->speed_m1) / Pioneer3dx::D; // angular
    motor->SetSpeed(this->speed, this->turnrate);
}


Motors::~Motors()
{
    delete motor;
}
