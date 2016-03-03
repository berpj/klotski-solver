class Game
  attr_accessor :history

  def initialize()
    @history = {}
  end

  def display_victory(new_node, new_board)
    puts "\n\nWIN!\n\n"

    new_node.parentage.reverse.each do |node|
      Board.new(node.name).display
      #puts "Press SPACE...\n\n"
      #self.wait_for_spacebar
    end
    Board.new(new_board).display

    puts "Score: #{new_node.parentage.count}"
  end

  def wait_for_spacebar
    sleep 1 while $stdin.getch != " "
  end
end
