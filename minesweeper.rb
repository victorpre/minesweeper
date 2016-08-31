require './board.rb'
class Minesweeper
  def initialize(width, height, num_mines)
    @width = width
    @height = height
    @num_mines = num_mines
    @board = new_board
  end

  def new_board
    board = Board.new(self)
  end

  def board
    self.instance_variable_get("@board")
  end

  def still_playing?
    false
  end

  def play x,y
    if (valid_play?(x,y) && self.board.valid_bounds?(x,y))
      if self.board.has_bomb? x,y
        puts "Você perdeu! As minas eram:"
        puts self.board.board_state({xray: true}) # PrettyPrinter.new.print(game.board_state(xray: true))
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
      cell = self.board.body[x-1][y-1]
      if cell!="F"
        self.board.body[x-1][y-1]="F"
      elsif cell=="F"
        self.board.body[x-1][y-1]="."
      else

      end
      true
    end
    false
  end

  def valid_play? x,y
    cell = self.board.body[x-1][y-1]
    cell!="F" && cell!=" "
  end
end

game = Minesweeper.new(3,3,2)
game.board.print_board
# game.flag 2,2
# game.board.print_board
puts "------------"
game.play 2,3
game.board.print_board
# game.board.board_state({xray: true})
