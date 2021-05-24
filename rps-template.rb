def rps(p_name, lives) # Rock paper scissors game function
  puts "Welcome to rock paper scissors"

  bot_lives = lives
  player_lives = lives
  choices = ["rock","paper","scissors"] # Choices available to bot and player

  while bot_lives > 0 || player_lives > 0
    puts "Enter your choice (r,p,s)"
    bot_choice = choices[rand(0..2)] # Randomize number 1-3 and change it to r,p,s
    player_choice = gets.downcase.strip # Remove arbitrary chars to fit r,p,s
    if !choices.include?(player_choice) # Player didnt enter valid choice
      puts "You didn't enter a valid choice"
      redo
    end
    if bot_choice == player_choice
      puts "Your choices were the same, try again"
      redo
    else
      if bot_choice == "rock"
        if player_choice == paper"
          puts "You win woohoo"
        else
          puts "You lose boohoo"
        end
      elsif

end
