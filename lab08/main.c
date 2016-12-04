#include "api_robot.h" /* Robot control API */

void delay();

/* main function */
void _start(void) 
{
  unsigned int distances[16];
  // set_speed_motor(35, 0);// esquerda
  set_speed_motor(35, 1); // direita
  // delay();
  // set_speed_motor(0, 0);
  aqui:
  set_speed_motor(0, 1);
  // while (1)
  // {
  //   set_speed_motor(35, 0);
  //   set_speed_motor(0, 1);
  //   delay();

  //   set_speed_motor(0, 0);
  //   set_speed_motor(35, 1);
  //   delay();
  // }

  /* While not close to anything. */
  // do {
  //   set_speed_motors(25,25);
  //   delay();
  //   set_speed_motor(10,0);
  //   delay();
  //   set_speed_motors(25,10);
  //   delay();
  //   read_sonars(distances);
  // } while ( ( distances[4] > 1200 ) && ( distances[3] > 1200 ));
}

/* Spend some time doing nothing. */
void delay()
{
  int i;
  /* Not the best way to delay */
  for(i = 0; i < 10000; i++ );  
}