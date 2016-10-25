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
// #include <thread>
#include <cstdlib>
#include <cstring>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <semaphore.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>


#define GPIO_MAP_SIZE 32




struct _shared_ {
    sem_t mutex;
    char data[GPIO_MAP_SIZE];
};




class GPIO_map {
public:
    GPIO_map();
    ~GPIO_map();

    int gpio_write(const std::string );
    int gpio_read(std::string *);

    static int POS( int );
static void delay_ms(unsigned int);


private:
    struct _shared_ *addr;
    int status;

};



#endif

