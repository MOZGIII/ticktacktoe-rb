#!/usr/bin/env ruby
require 'benchmark'
require "./common"

App.init!(ARGV)
Searcher.set_search_mode!(App.options.algorithm)

game = Game.new(O)

bm = Benchmark.measure {
  game.game_tick # only one game tick!
}

puts
puts "Benchmark:"
puts Benchmark::CAPTION
puts bm
