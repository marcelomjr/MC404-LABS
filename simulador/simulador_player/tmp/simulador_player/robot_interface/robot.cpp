#include "robot.h"


Robot::Robot(const char *str_host, int port )
{
    this->robot = new PlayerClient(str_host, port);
    this->sonars = new SONARcontrol(this->robot, 0);
    this->pwm_m = new PWMcontrol(this->robot, 0);
    this->reader = new std::thread(&Robot::read, this); 

    while ( this->sonars->sonars->done());
}


void Robot::setPWM_m0(const char WR, std::string DB)
{
    (WR == '1') ?  this->pwm_m->WR0.set(0) : this->pwm_m->WR0.reset(0);
    int j;
    for(int i = 0; i < Pioneer3dx::DAC_WIDTH; i++)
    {
        j = Pioneer3dx::DAC_WIDTH - 1 - i;
        (DB[i] == '1') ?  this->pwm_m->DB0.set(j) 
                       : this->pwm_m->DB0.reset(j);
    }
}

void Robot::setPWM_m1(const char WR, std::string DB)
{
    (WR == '1') ?  this->pwm_m->WR1.set(0) : this->pwm_m->WR1.reset(0);
    int j;
    for(int i = 0; i < Pioneer3dx::DAC_WIDTH; i++)
    {
        j = Pioneer3dx::DAC_WIDTH - 1 - i;
        (DB[i] == '1') ?  this->pwm_m->DB1.set(j) 
                       : this->pwm_m->DB1.reset(j);
    }    
}




void Robot::setPWM(const char WR0, std::string DB0, const char WR1, std::string DB1)
{
    this->setPWM_m0(WR0, DB0);          
    this->setPWM_m1(WR1, DB1);    
}


Robot::Robot()
{
    this->robot = new PlayerClient("localhost", 6665);
    this->sonars = new SONARcontrol(this->robot, 0);
    this->pwm_m = new PWMcontrol(this->robot, 0);
    this->reader = new std::thread(&Robot::read, this); 

    while ( this->sonars->sonars->done());
}


void Robot::read()
{
    for(;;)
    {
        this->robot->Read();
        std::this_thread::sleep_for(std::chrono::milliseconds(50));
    }
}




void Robot::sonarTrigger(const char b)
{
    this->sonars->setTrigger(b);
}

void Robot::selectSonar(const std::string bs)
{
    for(int i = 0; i < Pioneer3dx::MUX_SELECT; i++) 
    {
        (bs[i] == '0') ? this->sonars->selectSonar.reset(4-i-1)
            :   this->sonars->selectSonar.set(4-i-1);
    }
}


char Robot::sonarDone()
{
    char c;
    (this->sonars->done.to_string() == "0") ? c = '0' : c = '1';
    return c;
}


std::string Robot::getSonarData()
{
    return this->sonars->data.to_string();
}




Robot::~Robot()
{
    delete this->robot;
    delete this->pwm_m;
    delete this->sonars;
    delete this->reader;
}
