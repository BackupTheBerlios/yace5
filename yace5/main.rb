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
# You should have received a copy of the Affero General Public
# License in the COPYING file that comes with YaCE5. If
# not, write to Affero, Inc., 510 Third Street, Suite 225, San
# Francisco, CA 94107 USA.

require 'socket'
require 'mysql.rb'
require 'config.rb'
require 'user.rb'
require 'functions.rb'

sockloc = "/tmp/yace.sock"
@clients = Array.new
@users = Hash.new

puts "+ YaCE 5 starting up.."

puts "+ Opening UNIX socket at #{sockloc}.."
begin
  sock = UNIXServer.open(sockloc)
rescue
  puts "- Socket already in use.. Another server running?"
  exit
end

puts "+ Opening yace.conf config file.."
begin
  conf = Conf.new("yace.conf")
rescue 
  puts "- \"yace.conf\" doesn't exist!"
  exit
end

puts "+ Connecting to MySQL server.."
begin
  mysql = Y5_MySQL.new(conf.entry("mysql_host"), conf.entry("mysql_user"), conf.entry("mysql_pass"), conf.entry("mysql_db"))
rescue
  puts "- Cannot connect to MySQL server!"
  exit
end

puts "+ Waiting for interfaces.."

while sess = sock.accept do
  data = sess.recvfrom(1024)[0]
  
  t = parse_data(data)
  if t["type"] == 1 then
    puts "+ New Interface: #{data[1..-1]}"
    
    @clients << Thread.new(sess) { |mysess|
      Thread.current["sess"] = mysess
      while data = mysess.recvfrom(1024)[0] do
        t = parse_data(data)

	if t["type"] == 0 then
	  puts "- Interface disconnected!"
	  break
	end

	if t["type"] == 2 then
	  @users[t["args"][0]] = Y5_User.new(t["args"][0])
	end
	
	if t["type"] == 3 then
	  @users[t["args"][0]].setprop(t["args"][1],t["args"][2])
	end

	if t["type"] == 4 then
	  mysess.send("\1" + @users[t["args"][0]].getprop(t["args"][1]),0) #1 = Get Userprops Response
	end

	if t["type"] == 5 then
	  @users.each_value { |u|
	    resp = String.new
	    resp << "\2" # \2 = Get All Users response
	    resp << u.getnick << "\0"
	    u.allprops.each { |key, val|
	      resp << key << "\0" << val << "\0"
	    }
	    mysess.send(resp,0)
	  }
	end

	if t["type"] == 6 then
	  @clients.each { |thread|
	    begin
	      thread["sess"].send("\3#{t["args"][0]}\0#{t["args"][1]}",0)	      
	    rescue
	    end
	  }
	end
	
      end
    }    
  end
  
end
