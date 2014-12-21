require 'pry'
require_relative 'room'

class Game
  attr_accessor :room
  attr_accessor :exiting

  def game_loop
    orient
    describe_room
    offer_choices
    game_loop unless exiting
  end

  def orient
    self.room ||= Room.new('words/room_descriptions.txt')
  end

  def describe_room
    puts self.room.description
  end

  def offer_choices
    choice = player_input self.room.choices
    result = self.room.result(choice)
    self.send(result) if result
  end

  def leave_room
    self.room = nil
  end

  def player_input(choices)
    i = 1
    choices.each do |choice|
      puts "#{i}. #{choice}"
      i = i + 1
    end
    gets.chomp
  end

  def do_nothing
  end

  def exit_loop
    self.exiting = true
  end
end

Game.new.game_loop