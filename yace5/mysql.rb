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


# Converted sqlcon.cpp from YaCE3.

require 'mysql'

class Y5_MySQL
  def initialize(host, user, pw, database)
    begin
      @@mycon = Mysql.new(host, user, pw)
      @@mycon.select_db(database)
    rescue
      raise "Cannot Connect to MySQL server."
    end
  end

  def getString(key)
    begin
      @@mycon.query("SELECT value FROM strings WHERE `key` = '#{key}';").fetch_row[0]
    rescue
      return false
    end
  end

  def insertRegistry(nick, pw, mail)
    if @@mycon.escape_string(nick) != nick or
       @@mycon.escape_string(pw)   != pw   or
       @@mycon.escape_string(mail) != mail then; return false; end
    @@mycon.query("INSERT INTO `registry` (`handle`, `password`, `access`, `rights`, `color`, `email`) VALUES ('#{nick}',MD5('#{pw}'),NOW(),'0','#deface','#{mail}');")
    return true
  end

  def getText(key)
    begin
      @@mycon.query("SELECT value FROM texts WHERE `key` = '#{key}';").fetch_row[0]
    rescue
      return false
    end
  end
  
  def getReplaces
    res = Hash.new
    
    r = @@mycon.query("SELECT `key`, `value` FROM replaces")
    r.num_rows.times {
      h = r.fetch_hash
      res[h["key"]] = h["value"]
    }
    res
  end

  def getConfNum(key)
    begin
      @@mycon.query("SELECT value FROM confnum WHERE `key` = '#{key}';").fetch_row[0]
    rescue
      return false
    end
  end

  def getConfStr(key)
    begin
      @@mycon.query("SELECT value FROM confstr WHERE `key`='#{key}';").fetch_row[0]
    rescue
      return false
    end
  end
  
  def isReg(handle)
    begin
      if @@mycon.query("SELECT * FROM registry WHERE `handle` = '#{handle}';").num_rows > 0 then; return true; end
      return false
    rescue
      return false
    end
  end

  def getRegField(handle, key) # NOTE: Since we havent return-types, we can put getRegStr and getRegNum from YaCE3 in one function.
    begin
      @@mycon.query("SELECT #{key} FROM registry WHERE `handle` = '#{handle}';").fetch_row[0]
    rescue
      return false
    end
  end
  
  def setRegField(handle, key, val) # NOTE: Same as above ;)
    begin
      @@mycon.query("UPDATE registry SET #{key}='#{val}' WHERE `handle` = '#{handle}'")
      return true
    rescue
      return false
    end
  end
 
  def updateTime(handle)
    begin
      @@mycon.query("UPDATE registry SET access=NOW() WHERE `handle` = '#{handle}';")
      return true
    rescue
      return false
    end
  end 
end
