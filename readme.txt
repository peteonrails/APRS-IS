  
  Installation: gem install aprs-is
  Usage:
  
  aprs = Aprs.new("second.aprs.net", 20157, "callsign", "Version Number You Decide")
  aprs.connect #connects to aprs network
  aprs.packet("=4158.19N/08556.81W-", "Mesage to append")  #send a packet with your location (please replace location details)
  aprs.msg_raw #print to screen everything you see
  aprs.msg_filter #only print to screen messages containing your callsign and the message attached to it
  
  
  Updates: Later this will include functions to enable piping this data into other functions and variables