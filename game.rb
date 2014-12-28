require 'pry'
require_relative 'room'
require_relative 'cave'

class Game
  attr_accessor :room, :exiting, :x, :y, :dx, :dy

  def initialize

    @cave = Cave.new(30, 5)
    self.x = rand(10)
    self.y = rand(4)
    self.dx = 1
    self.dy = 0
  end

  def game_loop
    orient
    describe_room
    offer_choices

    game_loop unless exiting
  end

  def orient
    self.room = @cave.at(self.x, self.y)
    puts "x: #{x}, y: #{y}"
  end

  def describe_room
    puts self.room.description
  end

  def offer_choices
    choices = self.room.choices(self.dx, self.dy)
    choice = player_input choices
    chosen = choices[choice.to_i-1]
    self.send(result(chosen))
  end

  def results
    {
      "Forward" => :move_forward,
      "Turn Left" => :turn_left,
      "Turn Right" => :turn_right,
      "Turn Around" => :turn_around,
      "Say Goodbye" => :exit_loop,
    }
  end

  def result(input)
    results[input]
  end

  def move_forward
    self.x += self.dx
    self.y += self.dy
  end

  def turn_left
    if self.dx == 0
      self.dx = self.dy # (0, -1) (up) => (-1, 0) (left). (0, 1) (down) => (1, 0) (right)
      self.dy = 0
    else
      self.dy = -self.dx # (1, 0) (right) => (0, -1) (up). (-1, 0) (left) => (0, 1) (down)
      self.dx = 0
    end
  end

  def turn_right
    if self.dx == 0
      self.dx = -self.dy
      self.dy = 0
    else
      self.dy = self.dx
      self.dx = 0
    end
  end

  def turn_around
    self.dx = -self.dx
    self.dy = -self.dy
  end

  def player_input(choices)
    i = 1
    choices.each do |choice|
      puts "#{i}. #{choice}"
      i = i + 1
    end
    gets.chomp
  end

  def exit_loop
    self.exiting = true
  end
end

Game.new.game_loop