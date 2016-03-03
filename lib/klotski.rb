require "klotski/version"
require "tree"
require "io/console"
require "game.rb"
require "board.rb"

BOARD_WIDTH = 4

module Klotski
  def self.solve(file_name)
    board = Board.new()
    board.load_from_file(file_name)
    root_node = Tree::TreeNode.new(board.value, board)
    queue = [root_node]
    game = Game.new()

    while queue.any?
      current_node = queue.shift

      new_boards = current_node.content.get_new_boards(game)

      new_boards.each do |new_board|
        current_node << Tree::TreeNode.new(new_board.value, new_board)
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
