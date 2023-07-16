require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

def start_eye_reminders(event)
  event.channel.send_message("You are now subscribed to eye reminders.")
  interval = scheduler.every '1h' do
    begin
      event.channel.send_message("Please take an eye break now!")
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  return interval
end

def stop_eye_reminders(event, interval)
  event.channel.send_message("I have stopped eye reminders.")
  scheduler.unschedule(interval)
end
