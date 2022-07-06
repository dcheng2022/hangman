require 'pry-byebug'

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

def display_hangman(incorrect_counter)
  hangman_file = File.open('./hangman_ascii.txt', 'r')
  start_line = incorrect_counter * 7 + 1
  end_line = start_line + 6
  hangman_file.each { |line| puts line if (start_line..end_line).include?(hangman_file.lineno) }
  hangman_file.close
end

def display_word(word, matched_indices = [])
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

input_history = []
def validate_input(input_history)
  loop do
    input = gets.chomp.downcase
    next if input.match?(/[^a-z]/) || input_history.include?(input)

    input_history << input
    return input
  end
end

def display_history(input_history)
  puts input_history.join(', ')
end

# need to add incorrect_counter here after conversion into instance method
matched_indices = []
def compare_to_word(word, input, matched_indices)
  return matched_indices unless word.include?(input) && (input.length == word.length || input.length == 1)

  input_array = input.split('')
  word.split('').each_with_index { |chr, idx| matched_indices << idx if input_array.include?(chr) }
  matched_indices
end
