require "mtg_sdk"
require 'json'
require 'deep_merge'
require 'cube'

class MeteredCube

	DefaultCardListName = "cardlist.txt"

	@cube
	@color_targets
	@colors_actual

	def initialize(filename = DefaultCardListName)
		@cube = Cube.new(filename)

	end

	def set_color_targets(targets)
		@color_targets = targets

	end

	def measure_color_balance
		colors_actual = {}
		['White', 'Blue', 'Black', 'Red', 'Green', 'Colorless'].each do |color|
			colors_actual[color] = @cube.count_color(color)
		end
		colors_actual
	end

	def show_color_balance
		color_deltas = {}
		@colors_actual ||= measure_color_balance
		['White', 'Blue', 'Black', 'Red', 'Green', 'Colorless'].each do |color|
			color_deltas[color] = @color_targets[color].to_i - @colors_actual[color].to_i
		end
		color_deltas["Total"] = color_deltas.values.reduce(0, :+)
		color_deltas
	end


end