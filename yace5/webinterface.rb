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

sockloc = "/tmp/yace.sock"
myport = 7001

puts "+ Starting Up YaCE5 Web-Interface..."
puts "+ Trying to access socket at #{sockloc}.."
begin
  cl = UNIXSocket.open(sockloc)
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

cl.send("\1YaCE5 Web-Interface",0)

cl.close
