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
              else
                cantdo
              end
  end

  def disk
    ret = `df -h /dev/mapper/ubuntu14--vg-root /dev/sdb1 /dev/sdc1`.split("\n")
    result = ret[1..3].map {|row|
      elems = row.split(/\s+/)
      elems[0] +  " " + elems[3]
    }
    @eve.say(@id + "\n" + result.join("\n"),@status_id)
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

  def help
    result =<<~EOF
     "com anime" tweet latest recorded animes.
     "com disk" show usage of disk.
     "com help" show help.
    EOF
    @eve.say(@id + result,@status_id)    
  end

end

