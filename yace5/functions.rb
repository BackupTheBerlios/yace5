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

def parse_data(data)
  ret = Hash.new
  prefix = data[0].to_s

  if data.length == 0 then # Socket disconnected
    ret["type"] = 0
    return ret
   end
   
   if prefix == "1" then # Interface name
     ret["type"] = 1
     ret["args"] = [data[1..-1]]
     return ret
   end

   if prefix == "2" then # New User
     ret["type"] = 2
     ret["args"] = [data[1..-1]]
     return ret
   end
   
   if prefix == "3" then # Set Userprops
     ret["type"] = 3
     ret["args"] = data[1..-1].split("\0")
     return ret
   end

   if prefix == "4" then # Get Userprops
     ret["type"] = 4
     ret["args"] = data[1..-1].split("\0")
     return ret
   end
   
   if prefix == "5" then # Get all users
     ret["type"] = 5
     return ret
   end
   
end							    
