#include "gpio_map.h"


GPIO_map::GPIO_map()
{
    this->gpio_bstr = std::string("00000000000000000000000000000000");
    pthread_mutex_init(&this->gpio_mutex, NULL);
    this->debug_mode = false;
}


GPIO_map::GPIO_map(bool debug_mode)
{
    this->gpio_bstr = std::string("00000000000000000000000000000000");
    pthread_mutex_init(&this->gpio_mutex, NULL);
    this->debug_mode = (debug_mode) ? true : false;
}




GPIO_map::~GPIO_map()
{
    pthread_mutex_destroy(&this->gpio_mutex);
    dlclose(this->handle);                    
}




void GPIO_map::gpio_write( const std::string bstr)
{
    pthread_mutex_lock(&this->gpio_mutex);
    this->gpio_bstr = bstr;
    pthread_mutex_unlock(&this->gpio_mutex);
}


void GPIO_map::gpio_read(std::string *bstr)
{
    pthread_mutex_lock(&this->gpio_mutex);
    *bstr = this->gpio_bstr; 
    pthread_mutex_unlock(&this->gpio_mutex);
}


int GPIO_map::POS( int p )
{
    return GPIO_MAP_SIZE - 1 - p;
}



void GPIO_map::delay_ms(unsigned int d)
{
    usleep( 1000 * d );
}



void GPIO_map::gpio_connect()
{
    this->handle = dlopen("libgpio.so", RTLD_LAZY);

    std::cout << "-----------" << std::endl;
    if (!this->handle)
    {
        std::cerr << "Cannot open gpio connect library: " << dlerror() << std::endl;

    }
    else
    {
        typedef void (*start_connect)(GPIO_map *);
        
        dlerror();
        
        start_connect start_gpio_connect = (start_connect) dlsym(this->handle, "maker");
        
        const char *dlsym_error = dlerror();
        if (dlsym_error)
        {
            std::cerr << "Cannot load symbol 'maker': " << dlsym_error
                      << std::endl;
        }
        else
        {
            start_gpio_connect(this);
        }    
    }
}
