#ifndef _CLASS_LASER_H_
#define _CLASS_LASER_H_


#define BOOST_SIGNALS_NO_DEPRECATION_WARNING

#include <libplayerc++/playerc++.h>
using namespace PlayerCc;

class Laser {
public:
    Laser(PlayerClient *, unsigned short = 1);
    double getDistancia(int);
    bool   done();
    int    quantAngulos();
    ~Laser();
    

private:
    RangerProxy *laser;

    
};


#endif
