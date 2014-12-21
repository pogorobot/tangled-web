require 'pry'
require_relative 'room'

class Game
  attr_accessor :room

  def game_loop
    orient
    describe_room
    choice = player_input "Say Hello", "Say Goodbye", "Move On"
    if choice == '3'
      leave_room
    end
    game_loop unless choice == '2'
  end

  def orient
    self.room ||= Room.new('words/room_descriptions.txt')
  end

  def leave_room
    self.room = nil
  end

  def describe_room
    puts self.room.description
  end

  def player_input(*choices)
    i = 1
    choices.each do |choice|
      puts "#{i}. #{choice}"
      i = i + 1
    end
    gets.chomp
  end
end

Game.new.game_loop