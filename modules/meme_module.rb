require 'httparty'

def get_random_anime_image
  response = HTTParty.get('https://api.waifu.pics/sfw/waifu')
  if response.success?
    return response['url']
  else
    puts "Failed to fetch anime image: #{response.code} - #{response.message}"
    return nil
  end
end

def send_random_memes(event)
  event.channel.send_message("Here are some memes!")

  3.times do
    image_url = get_random_anime_image
    if image_url
      image_data = HTTParty.get(image_url).body
      File.open('image.jpg', 'wb') { |f| f.write(image_data) }
      event.channel.send_file(File.new('image.jpg'))
      sleep(1)
    else
      event.channel.send_message('Failed to get the image.')
    end
  end
end

def send_single_meme(event)
  event.channel.send_message("Here's your meme!")

  image_url = get_random_anime_image
  if image_url
    image_data = HTTParty.get(image_url).body
    File.open('image.jpg', 'wb') { |f| f.write(image_data) }
    event.channel.send_file(File.new('image.jpg'))
  else
    event.channel.send_message('Failed to get the image.')
  end
end
