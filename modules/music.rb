require 'soundcloud'
require 'yt'
require 'dotenv/load'
require 'pry'


def download_video(url)
  # Use the system call to execute the YouTube-DL command and download the video
  system("youtube-dl #{url}")
end

def find_and_queue_song(query)
  # Thử tìm kiếm từ YouTube
  youtube_results = find_youtube_song(query)
  if youtube_results && youtube_results.any?
    song_info = youtube_results.first
    queue_song(song_info['url'], song_info['title'])
    return song_info
  end
  return nil
end

def find_youtube_song(query)
  # Set up the YouTube API key
  Yt.configure do |config|
    config.api_key = ENV['YOUR_YOUTUBE_API_KEY']
  end

  # Perform the YouTube search with the given query
  search_results = Yt::Collections::Videos.new
                   .where(q: query, safe_search: 'none')
                   .first(5)

  # Return an array of song information (title and URL) for music videos
  music_videos = search_results.select { |result| result.snippet.description.include?('watch') }
  music_videos.map do |result|
    { 'title' => result.title, 'url' => "https://www.youtube.com/watch?v=#{result.id}" }
  end
end


# Mảng lưu thông tin các bài hát trong queue
$queue = []

# Queue bài hát với URL và tiêu đề
def queue_song(url, title)
  song_info = { 'url' => url, 'title' => title }
  $queue.push(song_info)
end

# Bỏ qua bài hiện tại và phát bài tiếp theo trong queue
def skip_song
  return if $queue.empty?

  # Lấy bài tiếp theo trong queue
  next_song = $queue.shift

  # Phát bài hát
  play_song(next_song['url'], next_song['title'])
end

def play_song(bot, event, url, title)
  server_id = ENV['YOUR_SERVER_ID'] # Replace with the server ID where the bot is running

  # Get the voice bot from the bot object
  voice_bot = bot.voice(server_id)

  # Check if the bot is already connected to a voice channel
  if voice_bot.nil?
    # Connect to the voice channel of the user who sent the command
    voice_channel = event.author.voice_channel

    if voice_channel.nil?
      event.respond('You need to be in a voice channel to use this command.')
      return
    end

    # Connect to the voice channel of the user
    bot.voice_connect(voice_channel)
    voice_bot = bot.voice(server_id)
  end

  # Check if the bot is already playing something
  if voice_bot.playing?
    bot.send_message(event.channel.id, "Added to the queue: #{title}")
  else
    # Download the video using youtube-dl
    download_video(url)

    # Play the downloaded file in the voice channel
    voice_bot.play_file('video.mp4')

    # Set a callback to execute when the song finishes
    voice_bot.after(30) do
      skip_song # Automatically skip to the next song after 30 seconds (you can adjust this duration)
    end
  end
end

