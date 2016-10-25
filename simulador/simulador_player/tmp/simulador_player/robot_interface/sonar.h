#ifndef _CLASS_SONAR_H_
#define _CLASS_SONAR_H_


#define BOOST_SIGNALS_NO_DEPRECATION_WARNING

#include <libplayerc++/playerc++.h>
using namespace PlayerCc;

class Sonar {
public:
    Sonar(PlayerClient *, unsigned short = 0);
    double getDistancia(int);
    bool   done();
    int    quantSonares();
    ~Sonar();
    

private:
    RangerProxy *sonar;

    
};


#endif
