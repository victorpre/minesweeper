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

  # Plant mines into the board
  def plant_mines num_mines
    planted_mines=0
    while planted_mines<num_mines
      mine_x = rand(0..self.width-1)
      mine_y = rand(0..self.height-1)
      if(self.body[mine_x][mine_y]!="#")
        self.body[mine_x][mine_y] = "#"
        planted_mines+=1
      end

    end
  end

  def board_state(**args)
    board_state = {:unknown_cell =>[],:clear_cell=>[], :bomb =>[], :flag =>[]}
    for i in 0..self.width-1
      for j in 0..self.height-1
        case self.body[i][j]
        when "."
          board_state[:unknown_cell] << [i+1,j+1]
        when "F"
          board_state[:flag] << [i+1,j+1]
        when "L"
          cell = {:cell_coord => [i+1,j+1], :neighbors_bombs_count => self.bombs_around(i+1,j+1) }
          board_state[:clear_cell] << cell

          # board_state[:clear_cell][:count] << [self.neighbors_bombs_count(i+1,j+1)]
          # TODO add number of nerighbor bombs
        end
      end
    end

    if args[:xray] && !self.game.still_playing?
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
      true
    else
      false
    end
  end

  def bombs_around x,y # 2,3
    counter = 0
    for i in 0..2
      for j in 0..2
        he=x-1+i
        wi=y-1+j
        if self.height>he && self.width>wi && wi>0 && he>0
          if has_bomb? he,wi
            puts "contei a bomba #{x},#{y}"
            counter+=1
          end
        end
      end
    end
    counter
  end

  def show_neighbors x,y
    if self.valid_bounds?(x,y)
      if !self.has_bomb?(x,y) && !self.discovered?(x,y) && !self.flag?(x,y)
        puts "foi pra #{x},#{y}"
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
  end

  def valid_bounds? x,y
    x <= self.width && y <= self.height && x>0 && y>0
  end

  def discovered? x,y
    self.body[x-1][y-1]=="L"
  end

  def discovered_count
    counter = 0
    for i in 1..self.height
      for j in 1..self.width
        counter+=1 if self.discovered?(i,j)
      end
    end
    counter
  end

  def body_size
    self.width*self.height
  end

  def flag_count
    counter = 0
    for i in 1..self.height
      for j in 1..self.width
        counter+=1 if self.flag?(i,j)
      end
    end
    counter
  end

  def flag? x,y
    self.body[x-1][y-1] == "F"
  end

  def print_board
    for i in 0..self.width-1
      for j in 0..self.height-1
        print self.body[i][j]
      end
      print "\n"
    end
    print "\n"
  end
end
