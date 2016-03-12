# coding: utf-8
require './eve.rb'

# eveの初期化
eve = Eve.new

yome = "@bot_yome"
ore = "@lovesaemi"

# timelineの監視
begin
  eve.timeline.userstream{|status|
    contents=status.text
    next if(contents=~/^RT/)

    id=status.user.screen_name
    id='@' + id + ' '

    # reply_answer
    if contents=~/#{yome}/
      postmatch.gsub!(/\s|[　]|\?|\？/, "")
        # QandA
        if(postmatch=~/誰|何処|だれ|どこ|何時|いつ|どうやって|どうして|何故|なぜ|どの|何|なに|どれ|は$/)
          eve.say(id+eve.docomoru_create_knowledge(postmatch), status.id)
        # 会話
        else
          eve.say(id+eve.docomoru_create_dialogue(postmatch), status.id)
        end
      next
    end

    # メンション以外の名前に反応
    if(contents=~/#{yome}/)
      called_name=['なに?', '呼んだ?','どうしたの?']
      eve.say(id+called_name.sample, status.id)
      next
    end

    #つぶやいたらリプライ
    if(id==ore)
      if contents =~ /愛|好/ && contents =~ /#{yome}/
        rep_lap=["私も愛してるよ","大好きだよ。"]
     
      else 
        rep_lap=["仕事しんさい","Twitterやめんさい"]
      end
      eve.say(id + rep_lap.sample, status.id)        
      next
    end
  }

rescue => e
  puts e.message
  retry
end
