# 2021-04-28

require 'discordrb'

bot = Discordrb::Bot.new token: '<token here>'

class RPS_Bot
  def initialize(username)
    @choices = [:rock, :paper, :scissors] # Symbols are easier to read imo
    # :occasion => response
    @responses = {
      :greeting =>  "OK! We have 3 tries each to win, write 'rock', 'paper' or 'scissors' when you're ready. I promise I wont cheat!",
      :invalidGuess =>  "invalid answer, try 'rock', 'paper' or 'scissors'",
      :sameGuess =>  "Our choices were equal, try again!",
      :pRockWin =>  "Argh! You smashed my scissors to a pulp!",
      :pRockLose =>  "Hah! My paper was too powerful for your rock!",
      :pPaperWin =>  "How?? You beat my rock with a paper?!",
      :pPaperLose =>  "You thought a piece of paper would beat my scissors, oh how wrong you were!",
      :pScissorsWIn =>  "Well done! You cut my paper to shreds",
      :pScissorsLose =>  "Boohoo, I made your scissors look like a bent spachula with my rock!",

      :pWin =>  "Well done #{username}, you are the superior being...",
      :pLose =>  "https://www.youtube.com/watch?v=j8PxqgliIno"
    }
  end

  def bot_choice()
    return @choices.rand(0..2)
  end

  def reply(message)
    response = @responses(message)
    return response != nil ? response : "Invalid symbol"
  end

end


# Actual bot in discord, does not make game choices but does send messages to discord
bot.message(start_with: '!rps') do |discord| # Starts when player writes '!rps'

  game = RPS_Bot.new(discord.user.name)
  bot_tries = 3
  player_tries = 3
  choices = [:rock, :paper, :scissors]

  discord.respond( game.reply(:greeting) )

  while botTries > 0 || playerTries > 0 # Start game
    b_choice = game.bot_choice().to_sym # :rock, :paper, or :scissors

    discord.user.await!(timeout: 300) do |p_message| # Expect player answer, p_message is the player's message from discord
    p_choice = p_message.message.content.strip.downcase.to_sym # convert players discord message to :symbol
    if !choices.include?(p_choice)
      discord.respond( game.reply(:invalidGuess) )
      redo
    elsif b_choice == p_choice
      discord.respond( game.reply(:sameGuess) )
      redo
    end
    case p_choice
    when :rock
      if b_choice == :scissors
        output = :pRockWin
        bot_tries -= 1
      elsif b_choice == :paper
        output = :pRockLose
        player_tries -= 1
      end
    when :paper
      if b_choice == :rock
        output = :pPaperWin
        bot_tries -= 1
      elsif b_choice == :scissors
        output = :pPaperLose
        player_tries -= 1
      end
    when :scissors
      if b_choice == :paper
        output = :pScissorsWin
        bot_tries -= 1
      elsif b_choice == :rock
        output = :pScissorsLose
        player_tries -= 1
      end
    end
    discord.respond( game.reply(output) )
  end
  if bot_tries == 0
    discord.respond( game.reply(:pWin) )
  elsif player_tries == 0
    discord.respond( game.reply(:pLose) )
  end
end

bot.run
