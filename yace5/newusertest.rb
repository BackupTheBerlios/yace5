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
cl = UNIXSocket.open(sockloc)
cl.send("\1Foo",0);
loop {
  data = cl.recvfrom(1024)[0]
#  if data[0] == 2 then
#    d = data[1..-1].split("\0")
#    puts "+ Caught User!"
#    puts "+ Nick: #{d.shift}"
#    @props = Hash.new
#    while !d.empty? do; @props[d.shift] = d.shift; end
#  end
  puts data
}
cl.close
