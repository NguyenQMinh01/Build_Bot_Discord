require 'discordrb'
require 'dotenv/load'
require 'youtube-dl.rb'
require 'pry'
require 'yt'
require 'open-uri'
require 'open3'

require_relative 'modules/meme_module'
require_relative 'modules/eye_module'
require_relative 'modules/music'



bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])  # Sử dụng biến môi trường

puts "This bot's invite URL is #{bot.invite_url}."
Yt.configuration.api_key = ENV['YOUR_YOUTUBE_API_KEY']

bot.message do |event|
  if event.message.content == '!ping'
    event.respond 'Pong!'
  end

  # Xử lý lệnh !meme
  if event.message.content == '!meme'
    current_time = Time.now
    $last_meme_time = Time.now - 10
    if current_time - $last_meme_time <= 5
      send_random_memes(event)
    else
      send_single_meme(event)
    end

    $last_meme_time = current_time
  end

  # Xử lý lệnh !eye
  if event.message.content == '!eye'
    $eye_reminder_interval = start_eye_reminders(event)
  end

  # Xử lý lệnh !play
  # if event.message.content.start_with?('!play')
  #   url = event.message.content.gsub('!play', '').strip

  #   # video = Yt::Collections::Videos.new.where(q: query).first
  #   # snippet = video.snippet
  #   # description = snippet.data["description"]

  #   # # Lấy URL từ chuỗi "description"
  #   # url = description.scan(/https:\/\/www\.youtube\.com\/watch\?v=[\w-]+/).first
  #   # binding.pry
  #   # if video
  #   #   voice_channel = event.user.voice_channel

  #   #   if voice_channel
  #   #     bot.voice_connect(voice_channel)
  #   #   puts "URL: #{url}"
  #   #     io = URI.parse(url).open

  #   #     binding.pry

  #   #     bot.voice(event.server).play_io(io)


  #   #     bot.voice(event.server).destroy
  #   #   else
  #   #     event.respond('Bạn cần tham gia một kênh thoại trước!')
  #   #   end
  #   # else
  #   #   event.respond('Không tìm thấy video!')
  #   # end
  #   query = event.message.content[6..-1].strip

  #   # Sử dụng youtube-dl.rb để lấy URL của video từ liên kết YouTube
  #   url = `youtube-dl -g -f bestaudio "#{query}"`.strip

  #   if url.empty?
  #     event.respond('Không tìm thấy video hoặc có lỗi khi tải xuống!')
  #     return
  #   end

  #   voice_channel = event.user.voice_channel
  #   if !voice_channel
  #     event.respond('Bạn cần tham gia một kênh thoại trước!')
  #     return
  #   end

  #   voice_bot = bot.voice_connect(voice_channel)

  #   # Phát nhạc từ URL bằng cách tải xuống và chơi bằng FFMpeg
  #   stream = open(url)
  #   voice_bot.play(stream)

  #   # Sau khi phát nhạc xong, đợi bot rời kênh thoại tự động
  #   voice_bot.on_end do
  #     voice_bot.destroy
  #   end
  # end

  # Xử lý lệnh !skip
  # if event.message.content == '!skip'
  #   # Bỏ qua bài hiện tại và phát bài tiếp theo trong queue
  #   skip_song
  # end

  # Xử lý lệnh !stop
  if event.message.content == '!stop'
    stop_eye_reminders(event, $eye_reminder_interval)
  end
end

bot.run
