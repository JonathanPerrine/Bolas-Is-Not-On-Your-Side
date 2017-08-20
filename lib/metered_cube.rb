require "mtg_sdk"
require 'json'
require 'deep_merge'
require_relative 'cube'
require 'pry'

class MeteredCube

	attr_accessor :cube

	DefaultCardListName = "cardlist.txt"

	@cube
	@color_targets = {"White" => 60, "Blue" => 60, "Black" => 60, "Red" => 60, "Green" => 60, "Gold" => 30, "Colorless" => 30}
	@colors_actual

	def initialize(filename = DefaultCardListName)
		@cube = Cube.new(filename)
	end

	def get_metrics_hash
		cb = show_color_balance
		dc = show_duplicate_count
		metrics_hash = { "Color Balance" => cb, "Duplicate Count" => dc }
	end

	def set_color_targets(targets)
		@color_targets = targets

	end

	def measure_color_balance
		colors_actual = {}
		['White', 'Blue', 'Black', 'Red', 'Green', 'Gold','Colorless'].each do |color|
			colors_actual[color] = @cube.count_color(color)
		end
		colors_actual
	end

	def show_color_balance
		color_deltas = {}
		@colors_actual ||= measure_color_balance
		['White', 'Blue', 'Black', 'Red', 'Green', 'Gold', 'Colorless'].each do |color|
			color_deltas[color] = @colors_actual[color].to_i - @color_targets[color].to_i
		end
		color_deltas["Total"] = show_color_balance_total
		color_deltas
	end

	def show_color_balance_total
		@colors_actual.values.reduce(0, :+)
	end

	def show_duplicate_count
		@cube.count_duplicates
	end


end