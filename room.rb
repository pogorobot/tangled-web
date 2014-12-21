class Room
  attr_accessor :description

  def initialize(filename)
    possible_descriptions = []
    File.open(filename).each do |line|
      line = line.chomp
      possible_descriptions << line if line.length > 0
    end

    self.description = possible_descriptions[rand(possible_descriptions.length).floor]
  end
end