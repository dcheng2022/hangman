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
