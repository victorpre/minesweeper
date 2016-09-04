require './board.rb'
require './pretty_printer.rb'

class Minesweeper
  attr_accessor :clicked_bomb
  def initialize(width, height, num_mines)
    @width = width
    @height = height
    @num_mines = num_mines
    @board = new_board
    self.clicked_bomb = false
  end

  def new_board
    board = Board.new(self)
  end

  def board
    self.instance_variable_get("@board")
  end

  def num_mines
    self.instance_variable_get("@num_mines")
  end

  def still_playing?
    if self.victory? || self.clicked_bomb == true
      false
    else
      true
    end
  end

  def play x,y
    if (valid_play?(x,y) && self.board.valid_bounds?(x,y))
      if self.board.has_bomb? x,y
        self.clicked_bomb = true
      else
        self.board.show_neighbors x,y
      end
      true
    else
      false
    end
  end

  def flag x,y
    if self.board.valid_bounds? x,y
      cell_value = self.board.body[x-1][y-1].value
      if cell_value!="F" && cell_value!="L"
        self.board.body[x-1][y-1].value="F"
      elsif cell_value=="F"
        self.board.body[x-1][y-1].value="."
      else

      end
      true
    end
    false
  end



  def victory?
    (self.num_mines == self.board.flag_count) && (self.board.body_size - self.num_mines == self.board.discovered_count) && (!self.clicked_bomb)
  end

  def valid_play? x,y
    cell_value = self.board.body[x-1][y-1].value
    !self.board.flag?(x,y) && !self.board.discovered?(x,y)
  end
end

width, height, num_mines = 10, 20, 50
@game = Minesweeper.new(width, height, num_mines)
@game.board.print_board
while @game.still_playing?
  valid_move = @game.play(rand(height), rand(width))
  valid_flag = @game.flag(rand(height), rand(width))
  if valid_move or valid_flag
    puts @game.board.board_state
  end
end

puts "Fim do jogo!"
if @game.victory?
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  PrettyPrinter.new.print(@game.board.board_state(xray: true))
  PrettyPrinter.new.print(@game.board.board_format)
end
