# Copyright (C) 2004 Tobias Bahls
#
# This file is a part of YaCE 5
#
# YaCE5 is free software, you can redistribute it and/or
# modify it under the terms of the Affero General Public License as
# Published by Affero, Inc., either version 1 of the License, or
# (at your option) any later version.
# 
# YaCE5 is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY, without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# Aferro General Public Licence for more details.
#
# You should have recieved a cpy of the Affero General Public
# Licencse in the COPYING file that comed with YaCE5. If
# not, write to Aferro, Inc., 510 third Street, Suide 225, San
# Francisco, CA 94107 USA.


require 'socket'
require 'functions.rb'

sockloc = "/tmp/yace.sock"
myport = 7001
@sessions = Array.new
@rt = Array.new

puts "+ Starting Up YaCE5 Web-Interface..."
puts "+ Trying to access socket at #{sockloc}.."
begin
  @cl = UNIXSocket.open(sockloc)
rescue
  puts "- Cannot open socket.. path correct? YaCE5-Core running?"
  exit
end
puts "+ Connected UNIX-Socket"
puts "+ Opening TCP socket on port #{myport}.."
begin
  s = TCPServer.new('localhost', myport)
rescue
  puts "- Cannot open TCP Socket on port #{myport}!"
end

@cl.send("\1YaCE5 Web-Interface",0)

u = Thread.new {
  while d = @cl.recvfrom(1024)[0] do
    if d[0] == 3 then
       user, text = d[1..-1].split("\0")
       @sessions.each { |sessio|
         begin
           sessio["inputqueue"].push("(#{user}) #{text}<br />") if sessio.alive?
	 rescue
	 end
       }
    end

    if d[0] == 1 then
      #p @rt.shift
      @rt.shift["prop"] = d[1..-1]
    end
    
  end
}

while sess = s.accept do
  @sessions << Thread.new(sess) { |mysess|
    while data = mysess.gets
      if data[0..2] == "GET" then # We got a GET-Request
        what = data.split(" ")[1]
	if what[0..5] == "/LOGIN" then
	  
	  Thread.current["inputqueue"] = Array.new
	  Thread.current["prop"] = String.new
	  
	  v = urlextract(what)
          mysess.puts("HTTP/1.1 200 OK")
  	  mysess.puts("Server: YaCE 5")
	  mysess.puts("Cache-control: no-cache")
	  mysess.puts("Content-type: text/html")
	  mysess.puts("\r\n")
	  mysess.puts("Willkommen im YaCE5!<br />")
	  
          @cl.send("\2#{v["name"]}",0)
	  sleep(0.1)
	  
	  @cl.send("\3" + v["name"] + "\0id\0#{v["id"]}",0)
	  
	  loop {
	    if Thread.current["inputqueue"].length > 0 then
	      mysess.puts(Thread.current["inputqueue"].shift)
	    end
	  }
	end
	if what[0..5] == "/INPUT" then
	  v = urlextract(what)
          
	  @rt.push(Thread.current)
	  @cl.send("\4#{v["name"]}\0id",0)
	  
	  sleep(0.1)
	  id = Thread.current["prop"]

	  if id[0] == 1 then; id = id[1..-1]; end
	  
	  if v["id"] = id then
	    v["input"].gsub!('+', ' ')
	    @cl.send("\6#{v["name"]}\0#{v["input"]}",0)
	  end
	  
	end
      end
    end
    @sessions.delete(Thread.current)
  }
end

cl.close
