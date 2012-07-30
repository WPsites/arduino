require "arduino"
require "socket"
require "mongrel"

# uncomment the below line to run this script as a daemon in the background, probably wise to add shutdown methods if running as a daemon
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
  
    #code here for moving servo through a range of movements
    @board.servoMove(9, 10) #pin, 0-180 deg val, duration in milliseconds 500 is default
    @board.servoMove(9, 30) #30 degrees for half a second
    @board.servoMove(9, 60) #60 degrees for half a second
    @board.servoMove(9, 90, 2000) #90 degrees for 2 seconds
    @board.servoMove(9, 120) #120 degrees for half a second
    @board.servoMove(9, 150) #150 degrees for half a second
    @board.servoMove(9, 180, 2000) #180 degrees for 2 second
    @board.servoMove(9, 10) #back to 10 degrees 

  end
  
  
end



server = Mongrel::HttpServer.new("0.0.0.0", 2000)

server.register("/take_photo", MyAwesomeHandler.new)

server_thread = server.run

# do your app logic here

server_thread.join




board.close
