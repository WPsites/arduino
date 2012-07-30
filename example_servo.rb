require "arduino"

    board = Arduino.new('/dev/tty.usbserial-A100MU2V')
    
    #declare output pins
    board.output(9,13)
    
    #Flash a couple of times to show setup is successfull and to expect the servo to move.
    2.times do
      
      board.setHigh(13)
      sleep(0.5)
      board.setLow(13)
      sleep(0.5)
    
    end

  
    #code here for moving servo through a range of movements
    board.servoMove(9, 10) #pin, 0-180 deg val, duration in milliseconds 500 is default
    board.servoMove(9, 30) #30 degrees for half a second
    board.servoMove(9, 60) #60 degrees for half a second
    board.servoMove(9, 90, 2000) #90 degrees for 2 seconds
    board.servoMove(9, 120) #120 degrees for half a second
    board.servoMove(9, 150) #150 degrees for half a second
    board.servoMove(9, 180, 2000) #180 degrees for 2 second
    board.servoMove(9, 10) #back to 10 degrees 





board.close
