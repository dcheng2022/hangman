require 'pry-byebug'

class Computer
  def initialize(name)
    @name = name
    @incorrect_counter = 0
    @input_history = []
    @matched_indices = []
    @word = select_word
    @game_status = false
  end

  def select_word
    word_bank_file = File.open('./google-10000-english-no-swears.txt', 'r')
    line_number = rand(1..9894)
    until word_bank_file.eof?
      word = word_bank_file.readline.chomp
      next unless line_number == word_bank_file.lineno

      next unless word.length > 4 && word.length < 13

      return word
    end
    select_word
  end

  def display_hangman
    hangman_file = File.open('./hangman_ascii.txt', 'r')
    start_line = incorrect_counter * 7 + 1
    end_line = start_line + 6
    hangman_file.each { |line| puts line if (start_line..end_line).include?(hangman_file.lineno) }
    hangman_file.close
  end

  def display_word
    word_array = word.split('')
    word_array.each_with_index do |chr, idx|
      if matched_indices.include?(idx)
        print "#{chr} "
      else
        print '__ '
      end
    end
    print "\n"
  end

  def validate_input
    loop do
      print "Enter a guess ('save' to save): "
      self.input = gets.chomp.downcase
      next if input.match?(/[^a-z]/) || input_history.include?(input) || input.empty?

      input_history << input unless input.match?('save')
      return input
    end
  end

  def check_save
    return true if input.match?('save')
  end

  def display_history
    puts "Previous guesses: #{input_history.join(', ')}"
  end

  def compare_to_word
    unless word.include?(input) && (input.length == word.length || input.length == 1)
      self.incorrect_counter += 1
      return matched_indices
    end
    input_array = input.split('')
    word.split('').each_with_index { |chr, idx| matched_indices << idx if input_array.include?(chr) }
    matched_indices
  end

  def check_win
    self.game_status = true if matched_indices.length == word.length || matched_indices.include?(word)
  end

  attr_accessor :incorrect_counter, :game_status, :word

  private

  attr_reader :name
  attr_accessor :input_history, :matched_indices, :input
end

def save_game(instance)
  File.open('data.txt', 'w+') do |f|
    Marshal.dump(instance, f)
  end
end

def load_game
  File.open('data.txt') do |f|
    Marshal.load(f)
  end
end

def game
  puts 'You are about to play a game of Hangman! The objective of the game is to guess a word by suggesting letters within a certain number of guesses.'
  computer = File.exist?('./data.txt') ? load_game : Computer.new('computer')
  computer.display_hangman
  computer.display_word
  loop do
    computer.validate_input
    if computer.check_save
      save_game(computer)
      return
    end
    computer.compare_to_word
    computer.display_hangman
    computer.display_word
    computer.display_history
    break unless computer.incorrect_counter < 6

    break if computer.check_win
  end
  message = computer.game_status ? 'You successfully guessed the word!' : "You failed to guess the word... it was #{computer.word}."
  puts message
end

game
