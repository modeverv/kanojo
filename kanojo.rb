require './eve.rb'
require './notify.rb'

# デーモン化
Process.daemon(true, true)
open("pid.txt", 'w') {|f| f << Process.pid}

# eveの初期化
eve = Eve.new

# システムリソースの取得系
notify = Notify.new

kanojo = "@bot_yome"
ore = "@lovesaemi"

# timelineの監視
begin
  eve.timeline.userstream{|status|
    contents = status.text

    next if(contents=~/^RT/)
    
    id = status.user.screen_name
    id = '@' + id + ' '

    if contents =~ /愛|好/ && contents =~ /#{kanojo}/
      pus :love
      rep_lap = ["私も愛してるよ","大好きだよ"]
      eve.say(id + rep_lap.sample, status.id)        
      next
    end     
    
    # reply_answer
    if contents =~ /#{kanojo}/
      postmatch = $'.gsub(/\s|[　]|\?|\？/, "").strip

      if postmatch.strip =~ /^com/
        notify.execute(postmatch.strip,eve,id,status.id)
        next
      end
      
      # QandA
      if(postmatch =~ /誰|何処|だれ|どこ|何時|いつ|どうやって|どうして|何故|なぜ|どの|何|なに|どれ|は$/)
        eve.say(id + eve.docomoru_create_knowledge(postmatch), status.id)
      # 会話
      else
        eve.say(id + eve.docomoru_create_dialogue(postmatch), status.id)
      end
      
      next
    end

    #つぶやいたらリプライ
    if id =~ /#{ore}/
      puts :ぶやいたらリプライ
      rep_lap = ["仕事しんさい","Twitterやめんさい"]
      eve.say(id + rep_lap.sample, status.id)        
      next
    end
  }

rescue => e
  puts e.message
  retry
end
