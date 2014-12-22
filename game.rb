require 'pry'
require_relative 'room'

class Game
  attr_accessor :room, :exiting, :previous_rooms, :position, :direction, :speed

  def initialize
    self.previous_rooms = []
    self.position = 0
    self.direction = 1
    self.speed = 1
  end

  def game_loop
    orient
    describe_room
    offer_choices

    game_loop unless exiting
  end

  def orient
    self.room = previous_rooms[position] || Room.new
    previous_rooms[position] = self.room
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
    self.position = rand(previous_rooms.length)
  end

  def move_forward
    self.position += velocity
    self.position = 0 if self.position < 0
  end

  def velocity
    self.speed * self.direction
  end

  def turn_around
    self.direction *= -1
  end

  def move_to(new_position)
    self.position = new_position
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