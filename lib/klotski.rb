require "klotski/version"
require "tree"
require "io/console"

module Klotski

  BOARD_WIDTH = 4

  def self.load_board(file_name)
    board = ''

    IO.foreach(file_name) { |line| board << line.strip }

    return board
  end

  def self.print_board(board)
    i = 1

    board.each_char do |piece|
      print piece
      print "\n" if i % BOARD_WIDTH == 0
      i += 1
    end
    print "\n"
  end

  def self.display_victory(new_node, new_board)
    puts "\n\nWIN!\n\n"

    new_node.parentage.reverse.each do |node|
      self.print_board node.name
      #puts "Press SPACE...\n\n"
      #self.wait_for_spacebar
    end
    self.print_board(new_board)

    puts "Résolu en #{new_node.parentage.count} coups"
  end

  def self.get_hash(board)
    hash = 0

    position = 1
    board.each_char do |piece|
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

  def self.wait_for_spacebar
    sleep 1 while $stdin.getch != " "
  end

  def self.get_l_position(board)
    for y in 0..4
      for x in 0..3
        if board[y * BOARD_WIDTH + x] == 'L'
          return [y, x]
        end
      end
    end
    return [-1, -1]
  end

  def self.move_up(board, y, x)
    new_board = board.clone
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

  def self.move_bottom(board, y, x)
    new_board = board.clone
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

  def self.move_left(board, y, x)
    new_board = board.clone
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

  def self.move_right(board, y, x)
    new_board = board.clone
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

  def self.get_points_distance(board)
    points = []

    for y in 0..4
      for x in 0..3
        points << [y, x] if board[y * BOARD_WIDTH + x] == '.'
        return (points[1][0] - points[0][0]).abs + (points[1][1] - points[0][1]).abs if points.count == 2
      end
    end

    return -1
  end

  def self.get_new_boards(node, history)
    new_boards = []

    board = node.name
    old_l_position = self.get_l_position(board)

    for y in 0..4
      for x in 0..3
        #if top left part of the piece
        if board[y * BOARD_WIDTH + x] != '.' && ((x == 0 || (board[y * BOARD_WIDTH + x] != board[y * BOARD_WIDTH + x - 1])) && (y == 0 || (board[y * BOARD_WIDTH + x] != board[(y - 1) * BOARD_WIDTH + x])))
          tmp_boards = []

          tmp_boards << self.move_up(board, y, x) unless (y == 0) || (y > 0 && board[(y - 1) * BOARD_WIDTH + x] != '.')
          tmp_boards << self.move_bottom(board, y, x) unless (y == 4) || (y == 3 && board[(y + 1) * BOARD_WIDTH + x] != '.') || (y == 2 && board[(y + 1) * BOARD_WIDTH + x] != '.' && board[(y + 2) * BOARD_WIDTH + x] != '.')
          tmp_boards << self.move_left(board, y, x) unless (x == 0) || (x > 0 && board[y * BOARD_WIDTH + x - 1] != '.')
          tmp_boards << self.move_right(board, y, x) unless (x == 3) || (x == 2 && board[y * BOARD_WIDTH + x + 1] != '.') || (x == 1 && board[y * BOARD_WIDTH + x + 1] != '.' && board[y * BOARD_WIDTH + x + 2] != '.')

          tmp_boards.each do |tmp_board|
            l_position = self.get_l_position(tmp_board)

            next unless l_position[0] >= old_l_position[0]

            next unless !history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s] || !(history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s].include? self.get_hash(tmp_board))

            next unless (l_position[0] != 0 || l_position[1] != 1) || (old_l_position[0] == 0 && old_l_position[1] == 1)

            next unless self.get_points_distance(tmp_board) <= 3

            new_boards << tmp_board
            history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s] = [] if !history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s]
            history[(l_position[0] * BOARD_WIDTH + l_position[1]).to_s] << self.get_hash(tmp_board)
          end
        end
      end
    end

    return new_boards
  end

  def self.solve(file_name)
    board = self.load_board(file_name)
    root_node = Tree::TreeNode.new(board)
    queue = [root_node]
    history = {}

    while queue.any?
      current_node = queue.shift

      new_boards = self.get_new_boards(current_node, history)

      new_boards.each do |new_board|
        current_node << Tree::TreeNode.new(new_board)
        queue << current_node[new_board]

        if new_board[4 * 4 + 1] == 'L' && new_board[4 * 4 + 2] == 'L'
          self.display_victory(current_node, new_board)
          exit
        end
      end
    end

    return true
  end
end
