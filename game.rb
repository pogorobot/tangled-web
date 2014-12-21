require 'pry'
require_relative 'room'

def game_loop
  describe_room(Room.new('words/room_descriptions.txt'))
  choice = player_input "Say Hello", "Say Goodbye"
  game_loop unless choice == '2'
end

def describe_room(room)
  puts room.description
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