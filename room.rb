class Room
  attr_accessor :description, :choices

  def initialize
    self.description = random_description_from(descriptions_path)
    self.choices = random_subset_from(choices_path)
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