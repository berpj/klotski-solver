require "klotski/version"
require "tree"
require "io/console"
require "game.rb"
require "board.rb"

BOARD_WIDTH = 4

module Klotski
  def self.get_new_boards(node, game)
    new_boards = []

    board = Board.new(node.name)
    old_l_position = board.get_l_position()

    for y in 0..4
      for x in 0..3
        #if top left part of the piece
        if board.value[y * BOARD_WIDTH + x] != '.' && ((x == 0 || (board.value[y * BOARD_WIDTH + x] != board.value[y * BOARD_WIDTH + x - 1])) && (y == 0 || (board.value[y * BOARD_WIDTH + x] != board.value[(y - 1) * BOARD_WIDTH + x])))
          tmp_boards = []

          tmp_boards << Board.new(board.move_up(y, x)) unless (y == 0) || (y > 0 && board.value[(y - 1) * BOARD_WIDTH + x] != '.')
          tmp_boards << Board.new(board.move_bottom(y, x)) unless (y == 4) || (y == 3 && board.value[(y + 1) * BOARD_WIDTH + x] != '.') || (y == 2 && board.value[(y + 1) * BOARD_WIDTH + x] != '.' && board.value[(y + 2) * BOARD_WIDTH + x] != '.')
          tmp_boards << Board.new(board.move_left(y, x)) unless (x == 0) || (x > 0 && board.value[y * BOARD_WIDTH + x - 1] != '.')
          tmp_boards << Board.new(board.move_right(y, x)) unless (x == 3) || (x == 2 && board.value[y * BOARD_WIDTH + x + 1] != '.') || (x == 1 && board.value[y * BOARD_WIDTH + x + 1] != '.' && board.value[y * BOARD_WIDTH + x + 2] != '.')

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

  def self.solve(file_name)
    board = Board.new()
    board.load_from_file(file_name)
    root_node = Tree::TreeNode.new(board.value)
    queue = [root_node]
    game = Game.new()

    while queue.any?
      current_node = queue.shift

      new_boards = self.get_new_boards(current_node, game)

      new_boards.each do |new_board|
        current_node << Tree::TreeNode.new(new_board.value)
        queue << current_node[new_board.value]

        if new_board.value[4 * BOARD_WIDTH + 1] == 'L' && new_board.value[4 * BOARD_WIDTH + 2] == 'L'
          game.display_victory(current_node, new_board.value)
          exit
        end
      end
    end

    return true
  end
end
