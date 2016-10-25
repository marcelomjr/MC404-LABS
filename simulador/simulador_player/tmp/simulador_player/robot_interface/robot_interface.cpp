#include "robot_interface.h"


robot_interface::robot_interface(GPIO_map * gm)
{
    this->robot_intf = new std::thread(&robot_interface::robot_player, this);
    this->gm = gm;
}

robot_interface::~robot_interface()
{
}



struct player_server * robot_interface::read_hostFile()
{
    
    std::ifstream host_file("player_server.inf");
    struct player_server *ret = NULL;
    std::string line;
    
    if (host_file.is_open())
    {
        ret = new struct player_server;
        std::getline(host_file, line); 
        ret->host = line;
        std::getline(host_file, line); 
        ret->port = atoi(line.c_str());
        host_file.close();
    }
    return ret;    
}



void robot_interface::robot_player()
{
    Robot *robot;
    struct player_server * playerServer = this->read_hostFile();
    if ( playerServer == NULL )
    {
        robot = new Robot();
    }
    else
    {
        robot = new Robot(playerServer->host.c_str(), playerServer->port );        
    }


    std::string val;
    std::string gpioSTR_old;
    std::string gpioSTR;
    std::stringstream debug_buffer;

    for(;;)
    {      
        gpioSTR_old = gpioSTR;
        this->gm->gpio_read(&gpioSTR);

        if ( ( gpioSTR != gpioSTR_old ) 
             && ( gpioSTR.length() == GPIO_MAP_SIZE ) )
        {
            robot->setPWM_m0(gpioSTR[GPIO_map::POS(18)], 
                             gpioSTR.substr(GPIO_map::POS(24), 6)); 

            robot->setPWM_m1(gpioSTR[GPIO_map::POS(25)], 
                             gpioSTR.substr(GPIO_map::POS(31), 6));

            if (this->gm->debug_mode)
            {
                debug_buffer << "------------ PLAYER LOG ----------------"
                             << std::endl;
                debug_buffer << "Read flag: " << gpioSTR[GPIO_map::POS(0)] 
                          << std::endl;        
                debug_buffer << "Trigger: " << gpioSTR[GPIO_map::POS(1)] 
                          << std::endl;        
                debug_buffer << "SONAR id: " << gpioSTR.substr(GPIO_map::POS(5),4) 
                          << std::endl;        
                debug_buffer << "SONAR data: " 
                          << gpioSTR.substr(GPIO_map::POS(17), 12) 
                          << std::endl;
                debug_buffer << "MOTOR[0]: "
                          << gpioSTR.substr(GPIO_map::POS(24), 6) 
                          << std::endl;
                debug_buffer << "MOTOR[1]: "
                          <<  gpioSTR.substr(GPIO_map::POS(31), 6) 
                          << std::endl;
                debug_buffer << "------------ END PLAYER LOG ----------------"
                             << std::endl;
                std::cout << debug_buffer.str();
                debug_buffer.flush();
            }

            robot->selectSonar(gpioSTR.substr(GPIO_map::POS(5),4));
            robot->sonarTrigger(gpioSTR[GPIO_map::POS(1)]);
                        
            if (robot->sonarDone() == '1')
            {
            val = robot->getSonarData();            
            gpioSTR[GPIO_map::POS(0)] = '1';

            for (int i = 0; i < Pioneer3dx::B_COUNTER_WIDTH; i++ )
            {
            gpioSTR[GPIO_map::POS(17)+i] = val[i];
        }
            this->gm->gpio_write(gpioSTR);
        }
            else
            { 
            gpioSTR[GPIO_map::POS(0)] = '0';
            this->gm->gpio_write(gpioSTR);
        }
        }

        GPIO_map::delay_ms(50);
        }

            delete robot;

        }



            extern "C" void * maker( GPIO_map * gm) {
            return (void *)new robot_interface(gm);
        }


