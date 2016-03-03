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

    return @value
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

  def move_up(y, x)
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

  def move_bottom(y, x)
    new_board = @value.clone
    piece = new_board[y * BOARD_WIDTH + x]

    y2 = y
    x2 = x

    if piece == 'C' || piece == 'D' || piece == 'E' || piece == 'F'
      while y2 < 4 && new_board[(y2 + 1) * BOARD_WIDTH + x2] == '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        y2 += 1
      end

    elsif piece == 'G' || piece == 'H' || piece == 'I' || piece == 'K'
      while y2 < 3 && new_board[(y2 + 2) * BOARD_WIDTH + x2] == '.'
        new_board[(y2 + 2) * BOARD_WIDTH + x2] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        y2 += 1
      end

    elsif piece == 'J'
      while y2 < 4 && new_board[(y2 + 1) * BOARD_WIDTH + x2] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[y2 * BOARD_WIDTH + x2 + 1] = '.'

        y2 += 1
      end

    elsif piece == 'L'
      while y2 < 3 && new_board[(y2 + 2) * BOARD_WIDTH + x2] == '.' && new_board[(y2 + 2) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[(y2 + 2) * BOARD_WIDTH + x2] = piece
        new_board[(y2 + 2) * BOARD_WIDTH + x2 + 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[y2 * BOARD_WIDTH + x2 + 1] = '.'

        y2 += 1
      end
    end

    return new_board
  end

  def move_left(y, x)
    new_board = @value.clone
    piece = new_board[y * BOARD_WIDTH + x]

    y2 = y
    x2 = x

    if piece == 'C' || piece == 'D' || piece == 'E' || piece == 'F'
      while x2 > 0 && new_board[y2 * BOARD_WIDTH + x2 - 1] == '.'
        new_board[y2 * BOARD_WIDTH + x2 - 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        x2 -= 1
      end

    elsif piece == 'G' || piece == 'H' || piece == 'I' || piece == 'K'
      while x2 > 0 && new_board[y2 * BOARD_WIDTH + x2 - 1] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 - 1] == '.'
        new_board[y2 * BOARD_WIDTH + x2 - 1] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 - 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = '.'

        x2 -= 1
      end

    elsif piece == 'J'
      while x2 > 0 && new_board[y2 * BOARD_WIDTH + x2 - 1] == '.'
        new_board[y2 * BOARD_WIDTH + x2 - 1] = piece
        new_board[y2 * BOARD_WIDTH + x2 + 1] = '.'

        x2 -= 1
      end

    elsif piece == 'L'
      while x2 > 0 && new_board[y2 * BOARD_WIDTH + x2 - 1] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 - 1] == '.'
        new_board[y2 * BOARD_WIDTH + x2 - 1] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 - 1] = piece
        new_board[y2 * BOARD_WIDTH + x2 + 1] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + 1] = '.'

        x2 -= 1
      end
    end

    return new_board
  end

  def move_right(y, x)
    new_board = @value.clone
    piece = new_board[y * BOARD_WIDTH + x]

    y2 = y
    x2 = x

    if piece == 'C' || piece == 'D' || piece == 'E' || piece == 'F'
      while x2 < 3 && new_board[y2 * BOARD_WIDTH + x2 + 1] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        x2 += 1
      end

    elsif piece == 'G' || piece == 'H' || piece == 'I' || piece == 'K'
      while x2 < 3 && new_board[y2 * BOARD_WIDTH + x2 + 1] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 + 1] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + 1] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + 1] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = '.'

        x2 += 1
      end

    elsif piece == 'J'
      while x2 < 2 && new_board[y2 * BOARD_WIDTH + x2 + 2] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + 2] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'

        x2 += 1
      end

    elsif piece == 'L'
      while x2 < 2 && new_board[y2 * BOARD_WIDTH + x2 + 2] == '.' && new_board[(y2 + 1) * BOARD_WIDTH + x2 + 2] == '.'
        new_board[y2 * BOARD_WIDTH + x2 + 2] = piece
        new_board[(y2 + 1) * BOARD_WIDTH + x2 + 2] = piece
        new_board[y2 * BOARD_WIDTH + x2] = '.'
        new_board[(y2 + 1) * BOARD_WIDTH + x2] = '.'

        x2 += 1
      end
    end

    return new_board
  end
end
