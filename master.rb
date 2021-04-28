# 2021-04-28

require 'discordrb'

bot = Discordrb::Bot.new token: '<token here>'

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

bot.run

#run bot with: ruby ping.rb

  

