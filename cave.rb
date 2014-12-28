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
    @grid.each do |row|
      row.each do |room|
        room.configure
      end
    end
    draw_map
  end

  def draw_map
    @grid.each do |row|
      row.each do |room|
        if room.has_exit?(room.x, room.y - 1)
          print "*."
        else
          print "**"
        end
      end
      puts "*"
      row.each do |room|
        if room.has_exit?(room.x - 1, room.y)
          print ". "
        else
          print "* "
        end
      end
      puts "*"
    end
    @grid[0].each do |column|
      print "**"
    end
    puts "*"
  end

  def at(x, y)
    @grid[y][x]
  end
end