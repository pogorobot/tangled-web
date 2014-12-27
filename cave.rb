require_relative 'room'
require 'pry'

class Cave
  attr_accessor :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @grid = []
    (0..width).each do |x|
      @grid[x] = []
      (0..height).each do |y|
        @grid[x] << Room.new(x, y, self)
      end
    end
  end

  def at(x, y)
    @grid[x][y]
  end
end