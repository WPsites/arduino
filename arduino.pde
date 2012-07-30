// variable to store the data from the serial port
int cmd = 0;

// command arguments
int cmd_arg[3];

int serialStatus = 0;

int custom_pulse = 1500;
int pulse_duration = 500;

void setup()
{
   // connect to the serial port
   Serial.begin(115200);
   // setup the output and input pins
   setupPins();
   serialStatus = 1;
}

void updateServo( int pin, int pulse){
  digitalWrite(pin, HIGH);
  delayMicroseconds(pulse);
  digitalWrite(pin, LOW);
  delay(20);  // 20 millisecond delay between pulses is required for the servo
}

void loop()
{

   if(serialStatus == 0)
   {
      Serial.flush();
      // setup the output and input pins
      setupPins();
      serialStatus = 1;
   }
   askCmd();

 

   {
      if(Serial.available()>0)
      {
         cmd = Serial.read();

         if(cmd == 0) //set digital low
         {
            cmd_arg[0] = readData();
            digitalWrite(cmd_arg[0],LOW);
         }
         else if(cmd == 1) //set digital high
         {
            cmd_arg[0] = readData();
            digitalWrite(cmd_arg[0],HIGH);
         }
         else if(cmd == 2) //get digital value
         {
            cmd_arg[0] = readData();
            cmd_arg[0] = digitalRead(cmd_arg[0]);
            Serial.write(cmd_arg[0]);
         }
         else if(cmd == 3) // set analog value
         {
            Serial.println("I'm in the right place");
            cmd_arg[0] = readData();
            cmd_arg[1] = readHexValue();
            analogWrite(cmd_arg[0],cmd_arg[1]);
         }
         else if(cmd == 4) //read analog value
         {
            cmd_arg[0] = readData();
            cmd_arg[0] = analogRead(cmd_arg[0]);
            Serial.println(cmd_arg[0]);
         }
         else if(cmd == 5)
         {
            serialStatus = 0;
         }
         if (cmd==6)
        {
         // Serial.println("I'm moving a servo");
          //cmd_arg[1] = 2000;
          cmd_arg[0] = readData();
          cmd_arg[1] = byte (readData()); //THIS READ DATA JUST NEEDS FIXING. IF YOU MODIFY THE CUSTOM_PULSE BELOW IT WORKS FINE. IF YOU TRY USING DATA PASSED IN IT DOESNT..
          cmd_arg[2] = byte (readData()); //THIS READ DATA JUST NEEDS FIXING. IF YOU MODIFY THE CUSTOM_PULSE BELOW IT WORKS FINE. IF YOU TRY USING DATA PASSED IN IT DOESNT..
          
            
           // custom_pulse = (cmd_arg[1] * 10) + 600;
           custom_pulse = map(cmd_arg[1], 0, 180, 600, 2400);
           pulse_duration = int(cmd_arg[2]) * 10;
    
  
             unsigned long startTime;
  
             startTime = millis();  // set our timer
             while(millis() - startTime <   pulse_duration) {  // loop for half a second
                 updateServo(cmd_arg[0], custom_pulse); //pin, pulse
             }
  
  
  
        }
         else
         {
            // invalid command
         }
      }
   }
}

char readData()
{
   askData();

   while(1)
   {
      if(Serial.available() > 0)
      {
         return Serial.read();
      }
   }
}


//read hex value from serial and convert to integer
int readHexValue()
{
   int strval[2];
   int converted_str;

   while(1)
   {
      if(Serial.available() > 0)
      {
         strval[0] = convert_hex_to_int(Serial.read());
         break;
      }
   }

   askData();

   while(1)
   {
      if(Serial.available() > 0)
      {
         strval[1] = convert_hex_to_int(Serial.read());
         break;
      }
   }

   converted_str = (strval[0]*16) + strval[1];
   return converted_str;
}


int convert_hex_to_int(char c)
{
   return (c <= '9') ? c-'0' : c-'a'+10;
}


void askData()
{
   Serial.println("?");
}


void askCmd()
{
   askData();
   while(Serial.available() <= 0)
   {}
}


void setupPins()
{
   // wait for serial data, to define the outputs
   while(Serial.available() < 1)
   {
      // first byte of number of pins, 
      // then each byte is a pin to activate
      cmd = readData();
      for(int i=0; i < cmd; i++)
      {
         cmd_arg[0] = readData();
         pinMode(cmd_arg[0], OUTPUT);
      }
      break;
   }

   // wait for serial data, to define the inputs
   while(Serial.available() < 1)
   {
      // first byte of number of pins, 
      // then each byte is a pin to activate
      cmd = readData();
      for(int i=0; i < cmd; i++)
      {
         cmd_arg[0] = readData();
         pinMode(cmd_arg[0], INPUT);
      }
      break;
   }
}