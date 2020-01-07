/*
  Hotspot 1D
  2018 Cristian Delgado (Nehenemi Labs), Dr. Miguel Condes Lara (INB UNAM Juriquilla)

  An arduino shield for measuring inflamation.
  
  Libraries:
  Adafruit Unified Sensor By Adafruit
  Adafruit TMP006 By Adafruit

  Circuit:
  BTN1 -> 8
  BTN2 -> 9
  LM35 -> A3

  
*/


//Libraries

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_TMP006.h"


//Defines
#define SECONDS 0.5

//Objects
Adafruit_TMP006 tmp006;


void setup()
{
  Serial.begin(9600);
  if(!tmp006.begin())
  {
    Serial.println("No sensor found!");
    while(1);
  }

}

void loop()
{
  
  delay((int)(SECONDS*1000));
  Serial.println(tmp006.readObjTempC());
  
}
