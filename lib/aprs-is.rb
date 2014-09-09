require 'socket'

class Aprs
  def initialize(server, port, call, version)
    @server  = server
    @port    = port
	@call = call
	@version = version
  end
  
  def connect
	@socket = TCPSocket.open(@server, @port)
	@socket.puts "#{@server} #{@port}"
	pass = self.passcode(@call.upcase)
	@socket.puts "user #{@call.upcase} pass #{pass} ver \"#{@version}\""
  end
  
  
    def msg_filter()
		until @socket.eof? do
		msg = @socket.gets
		self.msg_dis(msg)
	 	end
    end
	
    def msg_raw()
		until @socket.eof? do
		msg = @socket.gets
		self.msg_dis_raw(msg)
	 	end
    end	
	
  
  def msg_dis(msg)
	Thread.new do
		msg.gsub!(/.*::/, "").gsub!(/\s*[:]/, ": ") #filters out data leaving only callsign and message
		puts "Debug(Incomming): #{msg}" if msg =~ /#{@call.upcase}/ 
		end
   end
   
    def msg_dis_raw(msg)
		Thread.new do
		puts "Debug(Incoming): #{msg}"
		end
   end

   def send_msg(msg, sendto)
		@socket.puts "#{@call.upcase}>APRS,TCPIP*,qAC,THIRD::#{sendto.upcase}   :#{msg}" #3 spaces between call and msg
   end
  
  def packet(position, comment)
		init = "#{@call.upcase}>APRS,TCPIP*:"
		send = "#{init}#{position} #{comment}"
		puts "Debug(Outgoing): #{send}"
		@socket.puts "#{send}"
  end
  
  def passcode(call_sign) ## credit to https://github.com/xles/aprs-passcode/blob/master/aprs_passcode.rb
	call_sign.upcase!
	call_sign.slice!(0,call_sign.index('-')) if call_sign =~ /-/
	hash = 0x73e2
	flag = true
	call_sign.split('').each{|c|
	hash = if flag
	(hash ^ (c.ord << 8))
		else
		(hash ^ c.ord)
		end
	flag = !flag
	}
	hash & 0x7fff
   end
end

