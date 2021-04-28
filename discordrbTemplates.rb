# Start the game by typing "!game" in chat.
bot.message(start_with: '!game') do |event|
    # Pick a number between 1 and 10
    magic = rand(1..10)
  
    # Tell the user that we're ready.
    event.respond "Can you guess my secret number? It's between 1 and 10!"
  
    # Await a MessageEvent specifically from the invoking user.
    # Timeout defines how long a user can spend playing one game.
    # This does not affect subsequent games.
    #
    # You can omit the options hash if you don't want a timeout.
    event.user.await!(timeout: 300) do |guess_event|
      # Their message is a string - cast it to an integer
      guess = guess_event.message.content.to_i
  
      # If the block returns anything that *isn't* true, then the
      # event handler will persist and continue to handle messages.
      if guess == magic
        # This returns `true`, which will destroy the await so we don't reply anymore
        guess_event.respond 'you win!'
        true
      else
        # Let the user know if they guessed too high or low.
        guess_event.respond(guess > magic ? 'too high' : 'too low')
  
        # Return false so the await is not destroyed, and we continue to listen
        false
      end
    end
    event.respond "My number was: `#{magic}`."
  end




# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
bot = Discordrb::Commands::CommandBot.new token: 'B0T.T0KEN.here', prefix: '!'

bot.command :user do |event|
  # Commands send whatever is returned from the block to the channel. This allows for compact commands like this,
  # but you have to be aware of this so you don't accidentally return something you didn't intend to.
  # To prevent the return value to be sent to the channel, you can just return `nil`.
  event.user.name
end

bot.command :bold do |_event, *args|
  # Again, the return value of the block is sent to the channel
  "**#{args.join(' ')}**"
end

bot.command :italic do |_event, *args|
  "*#{args.join(' ')}*"
end

bot.command(:invite, chain_usable: false) do |event|
  # This simply sends the bot's invite URL, without any specific permissions,
  # to the channel.
  event.bot.invite_url
end

bot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
  # The `if` statement returns one of multiple different things based on the condition. Its return value
  # is then returned from the block and sent to the channel
  if max
    rand(min.to_i..max.to_i)
  elsif min
    rand(0..min.to_i)
  else
    rand
  end
end

bot.command :long do |event|
  event << 'This is a long message.'
  event << 'It has multiple lines that are each sent by doing `event << line`.'
  event << 'This is an easy way to do such long messages, or to create lines that should only be sent conditionally.'
  event << 'Anyway, have a nice day.'

  # Here we don't have to worry about the return value because the `event << line` statement automatically returns nil.
end