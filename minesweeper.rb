require './board.rb'
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
        puts "Você perdeu! As minas eram:"
        puts self.board.board_state({xray: true}) # PrettyPrinter.new.print(game.board_state(xray: true))
      else
        if self.board.bombs_around(x,y) == 0
          self.board.show_neighbors x,y
        end
      end
      true
    else
      false
    end
  end

  def flag x,y
    if self.board.valid_bounds? x,y
      cell = self.board.body[x-1][y-1].value
      if cell!="F"
        self.board.body[x-1][y-1].value="F"
      elsif cell=="F"
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
    cell = self.board.body[x-1][y-1].value
    !self.board.flag?(x,y) && cell!="L" # TODO change cell
  end
end

@game = Minesweeper.new(3,3,2)
@game.board.print_board
# game.flag 2,2
# game.board.print_board
# puts "------------"
# game.play 2,3
# game.board.print_board
# game.board.board_state({xray: true})
# puts game.still_playing?
