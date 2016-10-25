#ifndef _CLASS_ROBOT_INTERFACE_H_
#define _CLASS_ROBOT_INTERFACE_H_


#include <iostream>
#include <fstream>
#include <thread>
#include <gpio_map.h>

#include "robot.h"

struct player_server {
    std::string host;
    int port;
};




class robot_interface {
    
public:
    robot_interface(GPIO_map *);
    ~robot_interface();



private:

    std::thread *robot_intf;

    GPIO_map * gm;

    void robot_player();
    struct player_server * read_hostFile();

};



#endif
