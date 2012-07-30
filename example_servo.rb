require "arduino"
require "socket"
require "mongrel"

#Process.daemon






class MyAwesomeHandler < Mongrel::HttpHandler
  
  
  
  def initialize()
    
    @board = Arduino.new('/dev/tty.usbserial-A100MU2V')
    
    #declare output pins
    @board.output(9,13)
    
    #Flash a couple of times to show setup
    2.times do
      
      @board.setHigh(13)
      sleep(0.1)
      @board.setLow(13)
      sleep(0.1)
    
    end
    
    
  end
  
  
  def process(request, response)
    response.start(200) do |head, out|
      head["Content-Type"] = "text/plain"
      take_photo
      out.write("hi!\n")
    end
  end
  
  def take_photo
  
    #code here for moving servo to take photo
    @board.servoMove(9, 10) #pin, 0-180 deg val, duration in miliseconds
     @board.servoMove(9, 30)
      @board.servoMove(9, 60)
       @board.servoMove(9, 90, 2000)
        @board.servoMove(9, 120)
         @board.servoMove(9, 150)
          @board.servoMove(9, 180, 2000)
          @board.servoMove(9, 10) 

  end
  
  
end



server = Mongrel::HttpServer.new("0.0.0.0", 2000)

server.register("/take_photo", MyAwesomeHandler.new)

server_thread = server.run

# do your app logic here

server_thread.join




board.close
