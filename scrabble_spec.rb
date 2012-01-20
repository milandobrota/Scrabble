require './scrabble'

describe Scrabble do

  let(:scrabble) { Scrabble.new('EXAMPLE_INPUT.json') }

  describe 'parsing the input file' do
    it 'should parse the board' do
      scrabble.board.should == [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 1],
        [1, 2, 1, 1, 1, 3, 1, 1, 1, 1, 2, 1],
        [2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1],
        [1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      ]
    end

    it 'should parse the dictionary' do
      scrabble.dictionary.should == ['gyre', 'gimble', 'wabe', 'mimsy', 'borogoves', 'raths', 'outgrabe', 'jabberwock', 'jubjub', 'shun', 'frumious', 'bandersnatch', 'vorpal', 'manxome', 'foe', 'tumtum', 'uffish', 'whiffling', 'tulgey', 'burbled', 'galumphing', 'frabjous', 'callooh', 'callay', 'chortled', 'brillig', 'slithy', 'toves', 'gyre', 'gimble', 'mome']
    end

    it 'should parse the tiles' do
      scrabble.tiles.should == [
        ['i', 4],
        ['w', 5],
        ['g', 6],
        ['f', 7],
        ['s', 2],
        ['e', 1],
        ['l', 3],
        ['h', 8],
        ['n', 1],
        ['f', 7],
        ['b', 8],
        ['r', 12],
        ['u', 3],
        ['g', 6],
        ['i', 4],
        ['q', 9],
        ['o', 3],
        ['d', 2],
        ['s', 2],
        ['f', 7]
      ]
    end
  end

  it 'should find all possible words' do
    scrabble.words.should == %w(shun foe)
  end

  it 'should calculate a letter score' do
    scrabble.letter_score('w').should == 5
  end

  it 'should calculate a word score' do
    scrabble.scores_for_word('shun').should == [2, 8, 3, 1]
  end

  it 'should calculate a score' do
    scrabble.calculate_score('shun', 2, 4, 'h').should == 30
  end

  it 'should calculate board scores - horizontal' do
    scrabble.board_scores(2, 3, 4, 'h').should == [1, 1, 3, 1] 
  end

  it 'should calculate board scores - vertical' do
    scrabble.board_scores(0, 5, 5, 'v').should == [1, 2, 3, 1, 1] 
  end

  it 'should find the best horizontal move' do
    scrabble.best_horizontal_move_for('foe').should == {:word => 'foe', :row => 2, :col => 5, :value => 25, :direction => 'h'}
  end

  it 'should find the best vertical move' do
    scrabble.best_vertical_move_for('foe').should == {:word => 'foe', :row => 2, :col => 5, :value => 25, :direction => 'v'}
  end

  it 'should find the best move' do
    scrabble.best_move_for('foe').should == {:word => 'foe', :row => 2, :col => 5, :value => 25, :direction => 'h'}
  end

  it 'should solve the puzzle' do
    scrabble.solve.should == {:word => 'shun', :row=>1, :col=>5, :value=>32, :direction => 'v'}
  end
end
