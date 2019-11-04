/*
  Hotspot 1D
  2018 Cristian Delgado (Nehenemi Labs), Dr. Miguel Condes Lara (INB UNAM Juriquilla)

  An arduino shield for measuring inflamation.
  
  Libraries:
  Adafruit Unified Sensor By Adafruit
  Adafruit TMP006 By Adafruit
  
*/

//Libraries
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_TMP006.h"

//Defines
#define BTN1 9
#define READING_DELAY 25  //Reading delay in milliseconds
#define READING_TIME 25     //How many seconds to read

//Objects
Adafruit_TMP006 tmp;

void setup() {
  pinMode(BTN1,INPUT);
  Serial.begin(9600);
  if(!tmp.begin())
  {
    Serial.println("Sensor error!, Check connections and reset Arduino!");
  }
}

void loop() {
  if (digitalRead(BTN1) == HIGH)
  {
    timedReading();
  }
}

void timedReading(){
  unsigned long stopTime = millis() + (READING_TIME)*(1000);
  while(stopTime >= millis())
  {
    Serial.println(tmp.readObjTempC());
    delay(READING_DELAY);
  }
}
