class Board
  attr_accessor :value

  def initialize(val = '')
    @value = val
  end

  def display()
    i = 1

    @value.each_char do |piece|
      print piece
      print "\n" if i % BOARD_WIDTH == 0
      i += 1
    end
    print "\n"
  end

  def load_from_file(file_name)
    @value = ''

    IO.foreach(file_name) { |line| @value << line.strip }
  end

  def get_hash()
    hash = 0

    position = 1
    @value.each_char do |piece|
      if piece == 'H' || piece == 'G'
        hash += 1 * (position ** 10)
      elsif piece == 'I' || piece == 'K'
        hash += 2 * (position ** 10)
      elsif piece == 'E' || piece == 'F' || piece == 'D' || piece == 'C'
        hash += 3 * (position ** 10)
      elsif piece == 'J'
        hash += 4 * (position ** 10)
      elsif piece == 'L'
        hash += 5 * (position ** 10)
      else
        hash += 6 * (position ** 10)
      end

      position += 1
    end

    return hash
  end

  def get_l_position()
    for y in 0..4
      for x in 0..3
        if @value[y * BOARD_WIDTH + x] == 'L'
          return [y, x]
        end
      end
    end
    return [-1, -1]
  end

  def get_points_distance()
    points = []

    for y in 0..4
      for x in 0..3
        points << [y, x] if @value[y * BOARD_WIDTH + x] == '.'
        return (points[1][0] - points[0][0]).abs + (points[1][1] - points[0][1]).abs if points.count == 2
      end
    end

    return -1
  end

  def move_vertically(y, x, direction)
    new_board = @value.clone
    piece = new_board[y * BOARD_WIDTH + x]

    y2 = y
    x2 = x

    if piece == 'C' || piece == 'D' || piece == 'E' || piece == 'F'
      while y2 > 0 && new_board[(y2 - 1) * BOARD_WIDTH + x2] == '.'
        new_board[(y2 - 1) * BOARD_WIDTH + x2] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        y2 -= 1
      end

    elsif piece == 'G' || piece == 'H' || piece == 'I' || piece == 'K'
      while y2 > 0 && new_board[(y2 - 1) * BOARD_WIDTH + x2] == '.'
        new_board[(y2 - 1) * BOARD_WIDTH + x2] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = '.'

        y2 -= 1
      end

    elsif piece == 'J'
      while y2 > 0 && new_board[(y2 - 1) * BOARD_WIDTH + x2] == '.' && new_board[(y2 - 1) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[(y2 - 1) * BOARD_WIDTH + x2] = piece
        new_board[(y2 - 1) * BOARD_WIDTH + x2 + 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[y2 * BOARD_WIDTH + x2 + 1] = '.'

        y2 -= 1
      end

    elsif piece == 'L'
      while y2 > 0 && new_board[(y2 - 1) * BOARD_WIDTH + x2] == '.' && new_board[(y2 - 1) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[(y2 - 1) * BOARD_WIDTH + x2] = piece
        new_board[(y2 - 1) * BOARD_WIDTH + x2 + 1] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + 1] = '.'

        y2 -= 1
      end
    end

    return new_board
  end

  def move_vertically(y, x, direction)
    new_board = @value.clone
    piece = new_board[y * BOARD_WIDTH + x]

    y2 = y
    x2 = x

    if piece == 'C' || piece == 'D' || piece == 'E' || piece == 'F'
      while new_board[(y2 + direction) * BOARD_WIDTH + x2] == '.'
        new_board[(y2 + direction) * BOARD_WIDTH + x2] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        y2 += direction
      end

    elsif piece == 'G' || piece == 'H' || piece == 'I' || piece == 'K'
      while new_board[(y2 + (direction == -1 ? -1 : 2)) * BOARD_WIDTH + x2] == '.'
        new_board[(y2 + (direction == -1 ? -1 : 2)) * BOARD_WIDTH + x2] = piece
        new_board[(y2 + (direction == -1 ? 1 : 0)) * BOARD_WIDTH + x2] = '.'

        y2 += direction
      end

    elsif piece == 'J'
      while new_board[(y2 + direction) * BOARD_WIDTH + x2] == '.' && new_board[(y2 + direction) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[(y2 + direction) * BOARD_WIDTH + x2] = piece
        new_board[(y2 + direction) * BOARD_WIDTH + x2 + 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[y2 * BOARD_WIDTH + x2 + 1] = '.'

        y2 += direction
      end

    elsif piece == 'L'
      while new_board[(y2 + (direction == -1 ? -1 : 2)) * BOARD_WIDTH + x2] == '.' && new_board[(y2 + (direction == -1 ? -1 : 2)) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[(y2 + (direction == -1 ? -1 : 2)) * BOARD_WIDTH + x2] = piece
        new_board[(y2 + (direction == -1 ? -1 : 2)) * BOARD_WIDTH + x2 + 1] = piece
        new_board[(y2 + (direction == -1 ? 1 : 0)) * BOARD_WIDTH + x2] = '.'
        new_board[(y2 + (direction == -1 ? 1 : 0)) * BOARD_WIDTH + x2 + 1] = '.'

        y2 += direction
      end
    end

    return new_board
  end

  def move_horizontally(y, x, direction)
    new_board = @value.clone
    piece = new_board[y * BOARD_WIDTH + x]

    y2 = y
    x2 = x

    if piece == 'C' || piece == 'D' || piece == 'E' || piece == 'F'
      while new_board[y2 * BOARD_WIDTH + x2 + direction] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + direction] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        x2 += direction
      end

    elsif piece == 'G' || piece == 'H' || piece == 'I' || piece == 'K'
      while new_board[y2 * BOARD_WIDTH + x2 + direction] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 + direction] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + direction] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + direction] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = '.'

        x2 += direction
      end

    elsif piece == 'J'
      while x2 > 0 && new_board[y2 * BOARD_WIDTH + x2 + (direction == -1 ? -1 : 2)] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + (direction == -1 ? -1 : 2)] = piece
        new_board[y2 * BOARD_WIDTH + x2 + (direction == -1 ? 1 : 0)] = '.'

        x2 += direction
      end

    elsif piece == 'L'
      while new_board[y2 * BOARD_WIDTH + x2 + (direction == -1 ? -1 : 2)] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 + (direction == -1 ? -1 : 2)] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + (direction == -1 ? -1 : 2)] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + (direction == -1 ? -1 : 2)] = piece
        new_board[y2 * BOARD_WIDTH + x2 + (direction == -1 ? 1 : 0)] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + (direction == -1 ? 1 : 0)] = '.'

        x2 += direction
      end
    end

    return new_board
  end

  def get_new_boards(game)
    new_boards = []

    old_l_position = get_l_position()

    for y in 0..4
      for x in 0..3
        #if top left part of the piece
        if @value[y * BOARD_WIDTH + x] != '.' && ((x == 0 || (@value[y * BOARD_WIDTH + x] != @value[y * BOARD_WIDTH + x - 1])) && (y == 0 || (@value[y * BOARD_WIDTH + x] != @value[(y - 1) * BOARD_WIDTH + x])))
          tmp_boards = []

          tmp_boards << Board.new(move_vertically(y, x, -1)) unless (y == 0) || (y > 0 && @value[(y - 1) * BOARD_WIDTH + x] != '.')
          tmp_boards << Board.new(move_vertically(y, x, 1)) unless (y == 4) || (y == 3 && @value[(y + 1) * BOARD_WIDTH + x] != '.') || (y == 2 && @value[(y + 1) * BOARD_WIDTH + x] != '.' && @value[(y + 2) * BOARD_WIDTH + x] != '.')
          tmp_boards << Board.new(move_horizontally(y, x, -1)) unless (x == 0) || (x > 0 && @value[y * BOARD_WIDTH + x - 1] != '.')
          tmp_boards << Board.new(move_horizontally(y, x, 1)) unless (x == 3) || (x == 2 && @value[y * BOARD_WIDTH + x + 1] != '.') || (x == 1 && @value[y * BOARD_WIDTH + x + 1] != '.' && @value[y * BOARD_WIDTH + x + 2] != '.')

          tmp_boards.each do |tmp_board|
            l_position = tmp_board.get_l_position()

            next unless l_position[0] >= old_l_position[0]

            next unless !game.history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s] || !(game.history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s].include? tmp_board.get_hash())

            next unless (l_position[0] != 0 || l_position[1] != 1) || (old_l_position[0] == 0 && old_l_position[1] == 1)

            next unless tmp_board.get_points_distance() <= 3

            new_boards << tmp_board
            game.history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s] = [] if !game.history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s]
            game.history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s] << tmp_board.get_hash()
          end
        end
      end
    end

    return new_boards
  end
end
