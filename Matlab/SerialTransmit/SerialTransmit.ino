#include <Arduino_FreeRTOS.h>

// tasks
void blink(void *pvParameters);
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
    vTaskDelay(10 / portTICK_PERIOD_MS);
  }
}
