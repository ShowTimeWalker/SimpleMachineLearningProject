#include <Arduino_FreeRTOS.h>
#include <Wire.h>
#include "Adafruit_SGP30.h"
#include "DHT.h"
#include "string.h"

// tasks
void blink(void *pvParameters);
void readMicrophone(void *pvParameters);
void readCO2Concentration(void *pvParameters);
void readHumidityAndTemperature(void *pvParameters);
void writeToPort(void *pvParameters);

void setup() {
  Serial.begin(115200);
  while(!Serial);

  xTaskCreate(
    blink,
    "SystemIsRunning",
    128,  // stack size
    NULL, // parameters
    1,    // priority
    NULL  // handle 
  );

  xTaskCreate(
    readMicrophone,
    "ReadFromMicrophone",
    128,  // stack size
    NULL, // parameters
    1,    // priority
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
//    readHumidityAndTemperature,
//    "ReadHumidityAndTemperature",
//    512,  // stack size
//    NULL, // parameters
//    2,    // priority
//    NULL  // handle 
//  );

  xTaskCreate(
    writeToPort,
    "PrintToSerial",
    256,  // stack size
    NULL, // parameters
    1,    // priority
    NULL  // handle 
  );
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
//    Serial.print("Volumn: ");
//    Serial.println(volumn);
    vTaskDelay(5 / portTICK_PERIOD_MS);
  }
}

Adafruit_SGP30 sgp;
void readCO2Concentration(void *pvParameters) {
  sgp.begin();
  while (!sgp.IAQmeasure());
  while (true) {
    sgp.IAQmeasure();
//    Serial.print("TVOC ");
//    Serial.print(sgp.TVOC);
//    Serial.println(" ppb");
//    Serial.print("eCO2 ");
//    Serial.print(sgp.eCO2);
//    Serial.println(" ppm");
    vTaskDelay(40 / portTICK_PERIOD_MS);
  }
}

#define DHTPIN 2
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);
void readHumidityAndTemperature(void *pvParameters) {
  dht.begin();
  while(true) {
    Serial.print("Humidity: ");
    Serial.println(dht.readHumidity());
    Serial.print("Temperature: ");
    Serial.println(dht.readTemperature());
    vTaskDelay(100 / portTICK_PERIOD_MS);
  }
}

char msg[7];

void writeToPort(void *pvParameters) {
  int counter = 0;
  while(true) {
    Serial.write(msg);
    vTaskDelay(5 / portTICK_PERIOD_MS);
  }
}
