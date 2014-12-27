class Room
  attr_accessor :description, :id, :accessible

  def initialize(x, y, cave, id)
    self.description = random_description_from(descriptions_path)

    @x = x
    @y = y
    @cave = cave
    @possible_configurations = all_possible_configurations
    self.accessible = (x == 0 && y == 0)
    self.id = id
  end

  def all_possible_configurations
    exits = all_possible_exits
    one_from(exits) + two_from(exits) + three_from(exits)
  end

  def all_possible_exits
    exits = []
    if @x > 0
      exits << {x: @x - 1, y: @y}
    end
    if @y > 0
      exits << {x: @x, y: @y - 1}
    end
    if @x < @cave.width - 1
      exits << {x: @x + 1, y: @y}
    end
    if @y < @cave.height - 1
      exits << {x: @x, y: @y + 1}
    end
    exits
  end

  def one_from(choices)
    choices.map do |choice|
      [choice]
    end
  end

  def two_from(choices)
    results = []
    choices.each do |choice|
      choices.each do |other_choice|
        results << [choice, other_choice] if choices.index(choice) < choices.index(other_choice)
      end
    end
    results
  end

  def three_from(choices)
    results = []
    choices.each do |first_choice|
      choices.each do |second_choice|
        choices.each do |third_choice|
          results << [first_choice, second_choice, third_choice] if choices.index(first_choice) < choices.index(second_choice) && choices.index(second_choice) < choices.index(third_choice)
        end
      end
    end
    results
  end

  def previous_room
    if @x > 0
      return @cave.at(@x - 1, @y)
    elsif @y > 0
      return @cave.at(@cave.width - 1, @y - 1)
    else
      return self
    end
  end

  def next_room
    if @x < @cave.width - 1
      return @cave.at(@x + 1, @y)
    elsif @y < @cave.height - 1
      return @cave.at(0, @y + 1)
    else
      return self
    end
  end

  def constrain
    @possible_configurations.reject! do |configuration|
      asymmetrical?(configuration) || inaccessible?(configuration)
    end
  end

  def asymmetrical?(configuration)
    configuration.each do |exit|
      room = @cave.at(exit[:x], exit[:y])
      return false if room.id > self.id
      return true if room.has_exit?(@x, @y)
    end
    #and then also check that walls are walled
    return false
  end

  def inaccessible?(configuration)
    return false if self.accessible
    configuration.each do |exit|
      room = @cave.at(exit[:x], exit[:y])
      return false if room.id > self.id
      return false if room.accessible
    end
    return true
  end

  def has_exit?(x, y)
    return true unless @exits
    @exits.include?({x: x, y: y})
  end

  def configure
    puts self.id
    constrain
    if @possible_configurations.length == 0
      if previous_room == self
        puts "Failed to generate a cave."
        return
      end
      @possible_configurations = all_possible_configurations
      previous_room.nogood
    else
      @exits = @possible_configurations[rand(@possible_configurations.length)]
      set_accessible!
      if next_room == self
        puts "Success!"
        return
      end
      next_room.configure
    end
  end

  def set_accessible!
    @exits.each do |exit|
      if @cave.at(exit[:x], exit[:y]).accessible
        self.accessible = true
      end
    end
  end

  def nogood
    @possible_configurations.delete(@exits)
    configure
  end

  def descriptions_path
    'words/room_descriptions.txt'
  end

  def random_description_from(path)
    possible_descriptions = File.open(path).select do |line|
      line.chomp.length > 0
    end
    possible_descriptions[rand(possible_descriptions.length).floor]
  end

  def random_subset_from(path)
    File.open(path).select do |line|
      line.chomp.length > 0 && rand(100) < 75
    end
  end

  def choices(dx, dy)
    choices = []
    if @exits.include?({x: (@x + dx), y: @y + dy})
      choices << "Forward"
    end
    choices << "Turn Left"
    choices << "Turn Right"
    choices << "Turn Around"
    choices << "Say Goodbye"
  end
end