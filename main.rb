class Mastermind
  #available colors for the game.
  COLORS_OPTIONS =  ["red","blue","green","yellow","brown","pink"]
  def initialize(guesser)
    @guesser = "human" if guesser == "guesser"
    @guesser = "computer" if guesser == "creator"

    if @guesser == "human"
      #randomly chosen solution
      picked_colors = COLORS_OPTIONS
      @solution = COLORS_OPTIONS.sample(4)
      

    elsif @guesser == "computer"
      #human chooses @solution
      puts ""
      puts "Now you have to choose the colors for the game. "
      puts "You can use the following colors:"
      puts display_colors
      sleep(1.5)
      puts ""
      puts "Now, write the four color you want to choose, remember that one color can't be used twice:"
      array_choice = gets.split(",").map {|x| x.gsub(" ", "").chomp.downcase}

      until array_choice.all? {|color| COLORS_OPTIONS.include?(color)} && array_choice.length == 4 do
        puts ""
        puts "\nYour choice was invalid. Try again."
        puts "You should use 4 of the following colors: #{display_colors}"
        puts "What is your choice? (comma separated list)"
        array_choice = gets.split(",").map {|x| x.gsub(" ", "").chomp}
      end

      @solution = array_choice

    end

    @all_guesses = []
    @attempts = 0 
    @check_array = []
  end 

  public

  def get_guess()
    #gets the guess from a human and checks it.
    if @guesser == "human"
      if @all_guesses.length == 0
        puts ""
        puts "The available colors are: #{display_colors}"
        #sleep(1.5)
        puts "Enter your first guess (comma separated list of 4):"
      else 
        puts "Enter your next guess here:"
      end

      array_guess = gets.split(",").map {|x| x.gsub(" ", "").chomp.downcase}

      until array_guess.all? {|color| COLORS_OPTIONS.include?(color)} && array_guess.length == 4 do
        puts "\nYour guess was invalid. Try again."
        puts "You should use 4 of the following colors: #{display_colors}"
        puts "What is your guess? (comma separated list)"
        array_guess = gets.split(",").map {|x| x.gsub(" ", "").chomp}
        
      end
      @attempts += 1
      check_guess(array_guess)
    end

    #Logic for choosing guess on the computer. Basically just picks randomly and saves correct guesses.
    if @guesser == "computer"
      #first attempt is completely random
      if @attempts == 0
        @computer_guess = COLORS_OPTIONS.sample(4)
      else
        #gets last guess
        @last_guess = []
        @all_guesses.last.each do |value| 
          split_value = value.split(" ")
          @last_guess.push(split_value[0])
        end
        @last_feedback = @check_array
        #Adds last choice if it was correct or otherwise a random choice
        @new_guess = []
        @last_feedback.each_with_index do |feedback,index|
          if feedback == "✓"
            @new_guess.push(@last_guess[index])
          else
            @new_guess.push(COLORS_OPTIONS.sample(1)[0])
          end
        end
        @computer_guess = @new_guess
      end
      
      @attempts += 1
      check_guess(@computer_guess)
    end
  end
  
  #checks if the game has been won
  def won?()
    return @check_array.all?("✓") && @check_array.length > 3
  end

  def lost?()
    return @attempts >= 9
  end

  private

  #displays possible colors
  def display_colors
    return "#{COLORS_OPTIONS[0]}, #{COLORS_OPTIONS[1]}, #{COLORS_OPTIONS[2]}, #{COLORS_OPTIONS[3]}, #{COLORS_OPTIONS[4]}, and #{COLORS_OPTIONS[5]}"
  end

  def check_guess(guess)
    #checks each color against the solution and saves feedback in @all_guesses
    
    @check_array = []
    guess.each_with_index do |color, index|

      if color == @solution[index]
        @check_array.push("✓")
        next
      end

      if @solution.include?(color)
        @check_array.push("color")
        next
      end

      @check_array.push("x")

    end

    feedback = guess
    @check_array.each_with_index {|value, index| feedback[index] += " (#{@check_array[index]})"}
    @all_guesses.push(feedback)
    display_progress

  end

  def display_progress()
    #displays progress
    sleep(1)
    puts "__________________________________________________________________________________"
    puts ""
    puts "Your choice has been added to the game!"
    puts ""
    puts "The game looks like this now:"
    puts ""
    puts "-------------------------------------------------------------------"
    @all_guesses.each_with_index do |guess, index|
      puts "#{index+1}: #{guess[0]} | #{guess[1]} | #{guess[2]} | #{guess[3]}"
      puts "-------------------------------------------------------------------"
    end
  end
end


#The game starts here! 
#Just explains the game.
puts "Welcome to this game of Mastermind!"
puts ""
sleep(1.5)
puts "The goal is to guess the color scheme. The guesser will get feedback along the way."
sleep(1.5)
puts ""
puts "The rules are simple:"
puts "1. A color can only be in the solution once."
puts "2. The guesser has 8 attempts to win"
puts ""
sleep(3)
puts "Do you want to be the guesser or the creator of the secret code? (guesser/creator)"
#Figures out the roles
choice = gets.chomp.downcase
until choice == "guesser" || choice == "creator" do
  puts "Wrong input."
  puts "Write 'creator' or 'guesser':"
  choice = gets.chomp.downcase

end

#creates the class with the roles.
game = Mastermind.new(choice)

#continues the game until it has been won or lost.
while(!game.won? && !game.lost?) do
  game.get_guess()
end

#prints win or loss messages.
if game.won?
  puts "The game was won by the guesser!"
elsif game.lost?
  puts "The game was lost by the guesser..."
end

