#include <Arduino_FreeRTOS.h>
#include <Wire.h>
#include "Adafruit_SGP30.h"

// tasks
void blink(void *pvParameters);
void readMicrophone(void *pvParameters);
void readCO2Concentration(void *pvParameters);
void writeToPort(void *pvParameters);

void setup() {
  Serial.begin(9600);
  while(!Serial);

  xTaskCreate(
    blink,
    "SystemIsRunning",
    128,  // stack size
    NULL, // parameters
    0,    // priority
    NULL  // handle 
  );

  xTaskCreate(
    readCO2Concentration,
    "ReadCO2Concentration",
    128,  // stack size
    NULL, // parameters
    2,    // priority
    NULL  // handle 
  );

//  xTaskCreate(
//    readMicrophone,
//    "ReadFromMicrophone",
//    128,  // stack size
//    NULL, // parameters
//    1,    // priority
//    NULL  // handle 
//  );

//  xTaskCreate(
//    writeToPort,
//    "PrintToSerial",
//    128,  // stack size
//    NULL, // parameters
//    1,    // priority
//    NULL  // handle 
//  );
}

void loop() {

}

void blink(void *pvParameters __attribute__((unused))) {
  pinMode(LED_BUILTIN, OUTPUT);
  while(true) {
    digitalWrite(LED_BUILTIN, HIGH);
    vTaskDelay(500 / portTICK_PERIOD_MS);
    digitalWrite(LED_BUILTIN, LOW);
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}

int volumn = 0;
void readMicrophone(void *pvParameters) {
  while(true) {
    volumn = analogRead(A0);
    Serial.print("Volumn: ");
    Serial.println(volumn);
    vTaskDelay(20 / portTICK_PERIOD_MS);
  }
}

Adafruit_SGP30 sgp;
void readCO2Concentration(void *pvParameters) {
  sgp.begin();
  while (!sgp.IAQmeasure());
  while (true) {
    sgp.IAQmeasure();
    Serial.print("TVOC "); Serial.print(sgp.TVOC); Serial.println(" ppb");
    Serial.print("eCO2 "); Serial.print(sgp.eCO2); Serial.println(" ppm");
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

void writeToPort(void *pvParameters) {
  int a = 5;
  int b = 1;
  char msg[7] = "";
  while(true) {
    a += 1;
    b += 2;
    sprintf(msg, "%03d,%03d", a % 1000, b % 1000);
    Serial.write(msg);
    Serial.write(13);
    Serial.write(10);
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}
