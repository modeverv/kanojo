# coding: utf-8
require "sqlite3"

class Notify
  
  def execute command,eve,id,status_id

    @commandstr = command
    @eve = eve
    @id = id
    @status_id = status_id

    parse
    dotask

  end

  def parsestr str
    @command = str.split("com ").last.strip
    puts @command    
  end
  
  def parse 
    @command = @commandstr.split("com ").last.strip
    puts @command
  end

  def dotask
    @result = case 
              when @command =~ /disk/
                disk
              when @command =~ /anime/
                anime
              when @command =~ /help/
                help
              when @command =~ /clean/
                animeclean
              when @command =~ /gif/
                animegif
              else
                cantdo
              end
  end

  def disk
    ret = `df -h /dev/mapper/ubuntu14--vg-root /dev/sdb1 /dev/sdc1 /dev/sdd1`.split("\n")
    result = ret[1..-1].map {|row|
      elems = row.split(/\s+/)
      elems[0] +  " " + elems[3]
    }
    say("\n" + result.join("\n"))
  end

  def anime
    sqlfile = "/home/seijiro/crawler/crawler.db"
    sql =<<-SQL
select name from crawler order by created_at desc limit 15;
SQL
    db = SQLite3::Database.new(sqlfile)
    result = db.execute(sql,{ }).flatten.map{|e| e.gsub(/\..*$/,"") }.uniq
    db.close
    @eve.array_say(result,@id,@status_id)
  end

  def cantdo
    help
  end

  def animeclean
    `/home/seijiro/crawler/cleanup.sh  >>/home/seijiro/crawler/log/cleanup.log 2>&1 &`
    say("\n" + "きれいにするよー")
  end
  
  def animegif
    `/home/seijiro/crawler/gif.sh  >>/home/seijiro/crawler/log/gif.log 2>&1 &`
    say("\n" + "きれいにつくるよー")
  end

  def help
    result =<<~EOF
    
     "com anime" 
     "com disk"  
     "com clean" 
     "com gif"   
     "com help"  
    EOF
    say(result)
  end

  def say result
    @eve.say(@id + " " + result,@status_id)
  end

end

