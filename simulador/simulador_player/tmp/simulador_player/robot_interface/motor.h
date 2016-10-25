#ifndef _CLASS_MOTORS_H_
#define _CLASS_MOTORS_H_

#define BOOST_SIGNALS_NO_DEPRECATION_WARNING

#include <libplayerc++/playerc++.h>

#include "robots.h"

using namespace PlayerCc;





class Motors {

public:
    
    Motors(PlayerClient *, unsigned short = 0);
    void setSpeed_m0(double);
    void setSpeed_m1(double);
    void setSpeeds(double, double);
    ~Motors();

private:    
    Position2dProxy *motor;
    double speed_m0;
    double speed_m1;
    double turnrate;
    double speed;

    void refreshSettings();

};


#endif // _CLASS_MOTOR_H

