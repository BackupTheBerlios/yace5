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

class Y5_User  
  @@props = Hash.new
  @@nick = String.new

  def initialize(nick); @@nick = nick; end
  def setprop(name, value); @@props[name] = value; end
  def getprop(name); @@props[name]; end
  def getnick; @@nick; end
  def allprops; @@props; end
end
