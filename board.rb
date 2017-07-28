require './cell.rb'
require 'pry'
class Board
  attr_accessor :body, :height, :width, :num_mines
  def initialize(width, height, num_mines)
    self.num_mines = num_mines
    self.body = Array.new(height+1) { Array.new(width+1) }
    self.height = height
    self.width = width
#    @game = minesweeper
    self.initialize_cells
    if body_size > num_mines
      plant_mines(num_mines)
    else
      abort("Quantidade de minas superior ao tamanho do tabuleiro.")
    end
  end

  # Creates cells obj
  def initialize_cells
    for i in 1..self.height
      for j in 1..self.width
        self.body[i][j]= Cell.new(".")
      end
    end
  end

  # Plant mines into the board
  def plant_mines num_mines
    puts "Planting #{num_mines} mines.."
    planted_mines=0
    while planted_mines < num_mines
      col = rand(1..self.width)
      line = rand(1..self.height)
      if(self.body[line][col].value!="#")
        self.body[line][col].value = "#"
        planted_mines+=1
      end
    end
  end

  def board_state(**args)
    board_state = {unknown_cell: [], clear_cell: [], bomb: [], flag: []}
    for i in 1..self.height
      for j in 1..self.width
        case self.body[i][j].value
        when "."
          board_state[:unknown_cell] << [i,j]
        when "F"
          board_state[:flag] << [i,j]
        when "L"
          cell = {cell_coord:  [i,j], neighbors_bombs_count: self.bombs_around(i,j) }
          board_state[:clear_cell] << cell
        end
      end
    end

    if args[:xray]
      for i in 1..self.height
        for j in 1..self.width
          if self.body[i][j].value == "#"
            board_state[:bomb] << [i,j]
          end
        end
      end
    end
    puts board_state
  end

  def has_bomb? x,y
    if self.body[x][y].value=="#"
      true
    else
      false
    end
  end

  def bombs_around x,y
    counter = 0
    for i in -1..1
      for j in -1..1
        h=x+i
        w=y+j
        if self.height>=h && self.width>=w && w>0 && h>0
          puts "checking for bomb in #{h},#{w}"
          if has_bomb? h,w
            counter+=1
          end
        end
      end
    end
    counter
  end

  def show_neighbors x,y
    if self.valid_bounds?(x,y)
      self.body[x][y].neighbors_bombs = self.bombs_around(x,y)
      if !self.discovered?(x,y)
          self.discover(x,y)
        if !self.has_bomb?(x,y) && !self.flag?(x,y) && self.bombs_around(x,y)==0
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
  end

  def valid_bounds? x,y
    x <= self.height && y <= self.width && x>0 && y>0
  end

  def discover x,y
      self.body[x][y].value = "L"
  end

  def discovered? x,y
    self.body[x][y].value=="L"
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
    (self.width)*(self.height)
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
    self.body[x][y].value == "F"
  end

  def board_format
    {
      unknown_cell: '.',
      clear_cell: 'L',
      bomb: '#',
      flag: 'F'
    }
  end

  def print_board
    for i in 1..self.height
      print "#{i}:  |"
      for j in 1..self.width
        print "#{self.body[i][j].value}|"
      end
      print "\n"
    end
    print "\n"
  end
end
