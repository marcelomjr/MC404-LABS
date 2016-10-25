#ifndef _CLASS_ROBOT_H_
#define _CLASS_ROBOT_H_

#include <thread>
#include <string>



#include "PWMcontrol.h"
#include "SONARcontrol.h"
#include "robots.h"



class Robot {
public:
    Robot(const char *, int);
    Robot();

    void setPWM_m0(const char, std::string);
    void setPWM_m1(const char, std::string);

    void setPWM(const char, std::string, const char, std::string);

    void sonarTrigger(const char);
    void selectSonar(const std::string);
    char sonarDone();
    std::string getSonarData();


    ~Robot();

    PWMcontrol *pwm_m;
    SONARcontrol *sonars;

    

private:
    PlayerClient *robot;
    std::thread *reader;


    void read();

    
};


#endif
