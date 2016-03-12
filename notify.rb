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

  protected
  
  def parse 
    @command = @commandstr.split(":").last.strip
  end

  def dotask
    @result = case 
              when @command =~ /disk/
                disk
              when @command =~ /anime/
                anime
              else
                cantdo
              end
  end

  private
  
  def disk
    ret = `df -h /dev/sdb1 /dev/sdc1`.split("\n")
    result = ret[1..2].map {|row|
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
    result = "処理不能でしたよー"
    @eve.say(@id + result,@status_id)
  end

end

