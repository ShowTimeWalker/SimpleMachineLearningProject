#include <SoftwareSerial.h>

SoftwareSerial BTConfig(10, 11);  //10 - RX, 11 - TX
char c;

void setup() {
  Serial.begin(38400);
  BTConfig.begin(38400);

  Serial.println("start to config bluetooth");
}

void loop() {
  if (Serial.available()) {
    c = Serial.read();
    BTConfig.print(c);
  }
  if (BTConfig.available()) {
    c = BTConfig.read();
    Serial.print(c);
  }
}

/*
AT+ORGL    # 恢复出厂模式
AT+NAME=<Name>    # 设置蓝牙名称
AT+ROLE=0    # 设置蓝牙为从模式
AT+CMODE=1    # 设置蓝牙为任意设备连接模式
AT+PSWD=<Pwd>    # 设置蓝牙匹配密码
*/
