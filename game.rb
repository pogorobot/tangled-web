require 'pry'

def game_loop
  describe_room
  choice = player_input "Say Hello", "Say Goodbye"
  game_loop unless choice == '2'
end

def describe_room
  puts "Hello, World"
end

def player_input(*choices)
  i = 1
  choices.each do |choice|
    puts "#{i}. #{choice}"
    i = i + 1
  end
  gets.chomp
end

game_loop