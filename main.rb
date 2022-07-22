#picked colors
#current guess (array of 4)
#guess response (array of 4)
#logic of game


class Mastermind
  COLORS_OPTIONS =  ["red","blue","green","yellow","brown","pink"]
  def initialize()
    @solution = [COLORS_OPTIONS[rand(0..5)],COLORS_OPTIONS[rand(0..5)],COLORS_OPTIONS[rand(0..5)],
      COLORS_OPTIONS[rand(0..5)],];
    @all_guesses = []
    @attempts = 0 
    @check_array = []
  end

  public

  def get_guess()
    #should process the guess and then go to feedback
    #puts the guess into an array and removes spaces
    if @all_guesses.length == 0
      puts ""
      puts "The available colors are: #{display_colors}"
      #sleep(1.5)
      puts "Enter your first guess:"
    else 
      puts "Enter your next guess here:"
    end

    array_guess = gets.split(",").map {|x| x.gsub(" ", "").chomp}

    until array_guess.all? {|color| COLORS_OPTIONS.include?(color)} && array_guess.length == 4 do
      puts "\nYour guess was invalid. Try again."
      puts "You should use 4 of the following colors: #{COLORS_OPTIONS}"
      puts "What is your guess? (comma separated list)"
      array_guess = gets.split(",").map {|x| x.gsub(" ", "").chomp}
      
    end
    @attempts += 1
    check_guess(array_guess)
  end
  
  def won?()
    return @check_array.all?("✓") && @check_array.length > 3
  end

  def lost?()
    return @attempts >= 16
  end

  private

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
        @check_array.push("color ✓")
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
    #should display progress
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

game = Mastermind.new()

puts "Welcome to this game of Mastermind!"
puts ""
sleep(1.5)
puts "The goal is to guess the color scheme. You will get feedback along the way."
sleep(1.5)
while(!game.won? && !game.lost?) do
  game.get_guess()
end

if game.won?
  puts "The game was won by the guesser!"
elsif game.lost?
  puts "The game was lost by the guesser.."
end

