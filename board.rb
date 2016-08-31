class Board
  attr_accessor :width, :height
  def initialize(minesweeper)
    self.height = minesweeper.instance_variable_get("@height")
    self.width = minesweeper.instance_variable_get("@width")
    num_mines = minesweeper.instance_variable_get("@num_mines")
    @body = Array.new(width) { Array.new(height,'.') }
    plant_mines(num_mines)
  end

  def body
    self.instance_variable_get("@body")
  end

  # Plant mines into the board
  def plant_mines num_mines
    for i in 0..num_mines
      mine_x = rand(0..self.width-1)
      mine_y = rand(0..self.height-1)
      if(self.body[mine_x][mine_y]!="#")
        self.body[mine_x][mine_y] = "#"
      end
    end
  end

  def board_state(*args)
    if :xray
      # todo
    end
  end

  def print_board
    for i in 0..self.width-1
      for j in 0..self.height-1
        print self.body[i][j]
      end
      print "\n"
    end
  end
end
