# 2021-04-28

require 'discordrb'

bot = Discordrb::Bot.new token: '<token here>'

bot.message(start_with: '!rps') do |game|
  game.respond("OK! Let's start! Both of us have 3 tries to beat the other. Write `rock`, `paper`, or `scissors` when you are ready.") # Bot answers to player
  # Init game vars
  bot_tries = 3
  player_tries = 3
  choices = ["rock","paper","scissors"] # Choices available to bot and player

  while bot_tries > 0 || player_tries > 0 # Start game
    b_choice = choices[rand(0..2)] # Randomize number 1-3 and change it to r,p,s

    game.user.await!(timeout: 300) do |p_message| # Expect player answer, p_message is the player's message

    p_choice = p_message.message.content.downcase.strip
    if !choices.include?(p_choice)
      game.respond("You did not give a valid guess, please choose between `rock`, `paper`, or `scissors`.")
      redo
    end
    if b_choice == p_choice
      game.respond("Your choices were the same, try again!")
      redo
    end

    if b_choice == "rock"
      if p_choice == "paper"
        game.respond("You won! I chose rock and you beat it with paper.")
        bot_tries -= 1
      else # p_choice scissors
        game.respond("Boohoo your loss, quite literally. I smashed your scissors with rocks.")
        player_tries -= 1
      end
    elsif b_choice == "paper"
      if p_choice == "scissors"
        game.respond("Well done! You cut my paper into pieces with your scissors.")
        bot_tries -= 1
      else # p_choice rock
        game.respond("Oh well. Your rock was coated by my paper and you used a try.")
        player_tries -= 1
      end
    elsif b_choice == "scissors"
      if p_choice == "rock"
        game.respond("Argh! You broke my new scissors! Oh well I guess that's the price you pay for playing this game.")
        bot_tries -= 1
      else
        game.respond("Snip! Your paper has been shredded by my scissors!")
        player_tries -= 1
      end
    end
  end

  if bot_tries == 0
    game.respond("Well done #{game.user.name}! You beat me!")
  elsif player_tries == 0
    game.respond("Ahhh nice try. Maybe you will win next time.")
  end
end

bot.run
