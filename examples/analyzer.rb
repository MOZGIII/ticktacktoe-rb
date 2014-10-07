#!/usr/bin/env ruby
require "./common"

App.init!(ARGV)
Searcher.set_search_mode!(App.options.algorithm)

class State
  alias_method :orginal_initialize, :initialize
  def initialize(board, action)
    orginal_initialize(board, action)
    @@counter ||= 0
    @@counter += 1
  end

  def self.counter
    @@counter
  end
end

game = Game.new(O)
game.game_tick

puts
puts "States count: #{State.counter}"
