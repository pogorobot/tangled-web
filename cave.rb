require_relative 'room'
require 'pry'

class Cave
  attr_accessor :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @grid = []
    id = 1
    (0...height).each do |y|
      @grid[y] = []
      (0...width).each do |x|
        @grid[y] << Room.new(x, y, self, id)
        id += 1
      end
    end
    at(0, 0).configure
  end

  def at(x, y)
    @grid[y][x]
  end
end