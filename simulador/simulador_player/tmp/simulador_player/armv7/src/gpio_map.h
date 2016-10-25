/*

  GPIO MAP
  ---------------------------------
 |                                 |
  ---------------------------------
 31                                 0

 0     - ready
 1     - trigger
 5:2   - mux
 17:6  - sonar data

 18    - motor0 write
 24:19 - motor0 speed

 25    - motor1 write
 31:26 - motor1 speed

 */


#ifndef _CLASS_GPIO_MAP_H_
#define _CLASS_GPIO_MAP_H_

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <unistd.h>
#include <dlfcn.h>

#include <pthread.h>

#define GPIO_MAP_SIZE 32





class GPIO_map {
public:
    GPIO_map();
    GPIO_map(bool);
    ~GPIO_map();

    void gpio_write(const std::string );
    void gpio_read(std::string *);


    void gpio_connect();    

    static int POS( int );
    static void delay_ms(unsigned int);

    bool debug_mode;


private:

    std::string gpio_bstr;

    pthread_mutex_t gpio_mutex;

    void* handle;

};



#endif

