require 'json'

class Scrabble

  attr_accessor :board, :dictionary, :tiles

  def initialize(filename)
    parsed_input = JSON.parse(File.read(filename))
    @board = Scrabble.parse_board(parsed_input['board'])
    @dictionary = parsed_input['dictionary']
    @tiles = Scrabble.parse_tiles(parsed_input['tiles'])
  end

  def words
    @words ||= dictionary.select do |word|
      available_letters = tiles.collect(&:first)

      matching = true
      word.each_char do |word_letter|
        matching = false unless available_letters.delete(word_letter)
      end
      matching
    end
  end

  def letter_score(letter)
    @tiles.find {|letter_with_score| letter_with_score[0] == letter}.last
  end

  def scores_for_word(word)
    word.each_char.collect { |letter| letter_score(letter)  }
  end

  def board_scores(row, col, length, direction)
    raise "Out of bounds at (#{row}, #{col})" if direction == 'v' ? (row + length > board.size || col >= board[0].size) : (col + length > board[0].size || row >= board.size)
    if direction == 'h'
      (col...col+length).collect {|temp_col| board[row][temp_col]}
    elsif direction == 'v'
      (row...row+length).collect {|temp_row| board[temp_row][col]}
    end
  end

  def calculate_score(word, row, col, direction)
    board_score = board_scores(row, col, word.size, direction)
    word_score = scores_for_word(word)
    board_score.zip(word_score).inject(0) {|sum, el| sum + el[0] * el[1]}
  end

  def best_move_for(word)
    word.size
  end

  def best_horizontal_move_for(word)
    best_score = {:word => word, :row => 0, :col => 0, :value => 0}

    (0...(board.size)).each do |temp_row|
      (0...(board[0].size - word.length)).each do |temp_col|
        temp_score = calculate_score(word, temp_row, temp_col, 'h')
          best_score = {
            :word => word,
            :row => temp_row,
            :col => temp_col,
            :value => temp_score,
            :direction => 'h'
          } if temp_score > best_score[:value]
      end
    end

    best_score
  end

  def best_vertical_move_for(word)
    best_score = {:word => word, :row => 0, :col => 0, :value => 0}

    (0...(board.size - word.length)).each do |temp_row|
      (0...board[0].size).each do |temp_col|
        temp_score = calculate_score(word, temp_row, temp_col, 'v')
          best_score = {
            :word => word,
            :row => temp_row,
            :col => temp_col,
            :value => temp_score,
            :direction => 'v'
          } if temp_score > best_score[:value]
      end
    end

    best_score
  end

  def best_move_for(word)
    horizontal_move = best_horizontal_move_for(word)
    vertical_move = best_vertical_move_for(word)
    horizontal_move[:value] >= vertical_move[:value] ? horizontal_move : vertical_move
  end

  def solve
    candidates = words.collect {|word| best_move_for(word)}
    solution = candidates.sort_by {|x| x[:value] }.last
  end

  class << self
    def parse_board(lines)
      lines.collect do |line|
        line.split.collect(&:to_i)
      end
    end

    def parse_tiles(tiles)
      tiles.collect do |tile|
        [tile[0], tile[1..-1].to_i]
      end
    end
  end
end
