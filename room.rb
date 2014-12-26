class Room
  attr_accessor :description, :choices

  def initialize(x, y)
    self.description = random_description_from(descriptions_path)
    self.choices = random_subset_from(choices_path)

    @possible_configurations = all_possible_configurations
    @x = x
    @y = y
    @cave_width = 30
    @cave_height = 20
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
    if @x < @cave_width
      exits << {x: @x + 1, y: @y}
    end
    if @y < @cave_height
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
    return unless choices.length > 1
    results = []
    choices.each do |choice|
      choices.each do |other_choice|
        results << [choice, other_choice] if choices.index(choice) < choices.index(other_choice)
      end
    end
    results
  end

  def three_from(choices)
    return unless choices.length > 3
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

  def configure
    @configuration = @possible_configurations[rand(@possible_configurations).length]
    if violating_constraints
      @nogoods[@current_assumption] = @configuration
      @possible_configurations.delete @configuration
      if @possible_configurations.length > 0
        configure
      else
        @previous_room.nogood(@current_assumption)
      end
    else
      @next_room.assume(@configuration)
    end
  end

  def descriptions_path
    'words/room_descriptions.txt'
  end

  def choices_path
    'words/choices.txt'
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

  def choice(input)
    choices[input.to_i - 1].chomp
  end

  def results
    {
      "Forward" => :move_forward,
      "Backward" => :turn_around,
      "Say Goodbye" => :exit_loop,
      "Move On" => :leave_room
    }
  end

  def result(input)
    results[choice(input)]
  end
end