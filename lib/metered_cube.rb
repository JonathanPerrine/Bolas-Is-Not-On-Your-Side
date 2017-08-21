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

	def display_cube_metrics
		color_deltas = show_color_balance
		@colors_actual


		puts "Cube Color Balance\n"
		@color_targets.keys.each do |color|
			puts "[#{@colors_actual[color]}/#{@color_targets[color.to_s]}] #{color} cards (#{color_deltas[color.to_s]})\n"
		end

		puts "\nDuplicate Count:\n"
		puts show_duplicate_count
		puts "\nDuplicate Cards:\n"
		puts @cube.show_duplicates(@cube.card_detail_hash)
	end

	def set_color_targets(targets)
		@color_targets = targets

	end

	def measure_color_balance
		@cube.generate_card_color_hash(@cube.card_detail_hash)
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
		@cube.count_duplicates(@cube.card_detail_hash)
	end


end