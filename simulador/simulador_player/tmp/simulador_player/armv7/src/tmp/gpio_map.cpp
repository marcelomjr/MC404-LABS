#include "gpio_map.h"

GPIO_map::GPIO_map()
{
    this->status = 1;
    
    int fd = open("/tmp/gpio.io", O_RDWR | O_CREAT, S_IRUSR | S_IWUSR );

    this->status &= (fd == -1) ? 0 : 1;

    this->addr = (struct _shared_ *)mmap(NULL, sizeof(struct _shared_), 
                                         PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

    this->status &= (this->addr == MAP_FAILED) ? 0 : 1;

    this->status &= (write (fd, "", GPIO_MAP_SIZE) != 32) ? 0 : 1;        

    close(fd);    

    this->status &= ( sem_init(&addr->mutex, 1, 1) != 0 ) ? 0 : 1;

    this->gpio_write("00000000000000000000000000000000");



}



GPIO_map::~GPIO_map()
{
    munmap (this->addr, sizeof(struct _shared_));
}




int GPIO_map::gpio_write( const std::string bstr)
{ 
    if (this->status == 1 )
    {
        sem_wait(&this->addr->mutex);
        for(int i = 0; i < GPIO_MAP_SIZE; i++)
        {
            this->addr->data[i] = bstr[i];
        }        

        // this->status &= msync(this->addr, sizeof(struct _shared_), MS_SYNC);
        sem_post(&this->addr->mutex);

    }
    return (this->status - 1);
}


int GPIO_map::gpio_read(std::string *bstr)
{
    if (this->status == 1 )
    {
        sem_wait(&this->addr->mutex);  
        *bstr = this->addr->data;
        sem_post(&this->addr->mutex);            
    }    
    return (this->status - 1);
}


int GPIO_map::POS( int p )
{
    return GPIO_MAP_SIZE - 1 - p;
}



void GPIO_map::delay_ms(unsigned int d)
{
    // std::this_thread::sleep_for(std::chrono::milliseconds(d));
}
