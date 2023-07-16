require 'discordrb'
require 'dotenv/load'
require_relative 'modules/meme_module'
require_relative 'modules/eye_module'


bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])  # Sử dụng biến môi trường

puts "This bot's invite URL is #{bot.invite_url}."

bot.message do |event|
  if event.message.content == '!ping'
    event.respond 'Pong!'
  end

  # Xử lý lệnh !meme
  if event.message.content == '!meme'
    current_time = Time.now

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

  # Xử lý lệnh !stop
  if event.message.content == '!stop'
    stop_eye_reminders(event, $eye_reminder_interval)
  end
end

bot.run
