#include "api_robot.h" /* Robot control API */

void delay();

/* main function */
void _start(void) 
{
  unsigned int distances[16];

  /* While not close to anything. */
  while(1)
  {
     set_speed_motors(55,55);
      if (read_sonar(3) < 1200)
      {
          // vira parar a direita
         set_speed_motors(0,63);
         delay();
      }
      if (read_sonar(4) < 1200)
      {
          // vira parar a esquerda
         set_speed_motors(63,0);
         delay();
      }

   }
}

/* Spend some time doing nothing. */
void delay()
{
  int i;
  /* Not the best way to delay */
  for(i = 0; i < 10000; i++ );  
}
