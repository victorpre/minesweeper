class Board
  attr_accessor :width, :height
  def initialize(minesweeper)
    self.height = minesweeper.instance_variable_get("@height")
    self.width = minesweeper.instance_variable_get("@width")
    num_mines = minesweeper.instance_variable_get("@num_mines")
    @body = Array.new(width) { Array.new(height,'.') }
    @game = minesweeper
    plant_mines(num_mines)
  end

  # Getters
  def body
    self.instance_variable_get("@body")
  end

  def game
    self.instance_variable_get("@game")
  end

  def set_body x,y,val
    @body[x-1][y-1]=val
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
    board_state = {:unknown_cell =>[],:clear_cell=>[], :bomb =>[], :flag =>[]}
    for i in 0..self.width-1
      for j in 0..self.height-1
        case self.body[i][j]
        when "."
          board_state[:unknown_cell] << [i+1,j+1]
        when "F"
          board_state[:flag] << [i+1,j+1]
        else
          board_state[:clear_cell] << [i+1,j+1]
          # TODO add number of nerighbor bombs
        end
      end
    end
    if :xray && !self.game.still_playing?
      for i in 0..self.width-1
        for j in 0..self.height-1
          if self.body[i][j] == "#"
            board_state[:bomb] << [i+1,j+1]
          end
        end
      end
    end
    puts board_state
  end

  def has_bomb? x,y
    print_board
    if self.body[x-1][y-1]=="#"
      puts "bomba em #{x},#{y}"
      true
    else
      false
    end
  end

  def show_neighbors x,y
    puts "foi pra #{x},#{y}"
    if !self.has_bomb?(x,y) && self.valid_bounds?(x,y)
      self.body[x-1][y-1] = "L"
      show_neighbors(x-1,y-1) # Upper left
      show_neighbors(x,y-1) # Upper
      show_neighbors(x+1,y-1) # Upper right
      show_neighbors(x-1,y) # Left
      show_neighbors(x+1,y) # Right
      show_neighbors(x-1,y+1) # Bottom left
      show_neighbors(x,y+1) # Bottom
      show_neighbors(x+1,y+1) # Botom Right
    end

  end

  def valid_bounds? x,y
    x <= self.width && y <= self.height && x>0 && y>0
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
