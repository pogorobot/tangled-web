class Room
  attr_accessor :description, :choices

  def initialize(filename)
    self.description = random_description_from(filename)
    self.choices = random_subset_from(choices_filename)
  end

  def choices_filename
    'words/choices.txt'
  end

  def random_description_from(filename)
    possible_descriptions = File.open(filename).select do |line|
      line.chomp.length > 0
    end
    possible_descriptions[rand(possible_descriptions.length).floor]
  end

  def random_subset_from(filename)
    File.open(filename).select do |line|
      line.chomp.length > 0 && rand(100) < 75
    end
  end

  def choice(input)
    choices[input.to_i - 1].chomp
  end

  def results
    {
      "Say Goodbye" => :exit_loop,
      "Move On" => :leave_room
    }
  end

  def result(input)
    results[choice(input)]
  end
end