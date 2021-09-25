#include <Arduino_FreeRTOS.h>

// tasks
void blink(void *pvParameters);

void setup() {
  Serial.begin(9600);
  while(!Serial);

  xTaskCreate(
    blink,
    "SystemIsRunning",
    128,   // stack size
    NULL, // parameters
    0,    // priority
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
