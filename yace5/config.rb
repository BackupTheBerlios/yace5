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
	

class Conf
  @@entries = Hash.new

  def initialize(file)
      begin
        @file = File.open(file)
      rescue
        raise "Cannot open yace.conf"
      end
      @file.each_line { |l|
        l.chomp!
        if l[0] != 35 and l != "" then
	  @@entries[l.split("=")[0]] = l.split("=")[1]
	end
      }
  end

  def entry(w); @@entries[w]; end;
end
