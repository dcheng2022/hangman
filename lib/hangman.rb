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

def display_word(word)
  word_length = word.length
  word_length.times { print '__ ' }
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

incorrect_input = 0
def compare_to_word(word, input, incorrect_input)
  return incorrect_input += 1 unless word.include?(input) && input.length == word.length || input.length == 1

  matched_indices = []
  input_array = input.split('')
  word.split('').each_with_index { |chr, idx| matched_indices << idx if input_array.include?(chr) }
  matched_indices
end
