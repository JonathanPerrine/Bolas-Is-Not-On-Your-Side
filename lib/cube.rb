require "mtg_sdk"
require 'json'
require 'deep_merge'

class Cube
	attr_accessor :card_detail_hash

	DefaultCardListName = "cardlist.txt"
	@card_color_hash
	@card_detail_hash
	@casting_cost_hash

	def initialize(filename = DefaultCardListName)
		load_decklist_from_text(filename)
	end

	def load_decklist_from_text (filename)
		puts filename
		cardlist = File.open(filename, "r").read
		card_array = []
		card_count_hash = {}
		card_color_hash = {"White" => 0, "Blue" => 0, "Black" => 0, "Red" => 0, "Green" => 0, "Gold" => 0, "Colorless" => 0}
		cc_hash = {}

		cardlist.each_line do |line|
			card_name = line.match(/\s(.*)$/)[1]
			card_array << card_name
			card_count_hash[card_name] = line.match(/\A(\d+)/)[1]
		end

		card_detail_hash = {}
		card_array.each_slice(100) do |cards|
			MTG::Card.where(name: cards.join("|")).all.each do |card|
				count = card_count_hash[card.name].to_i

				card_hash = {color: map_colors(card.colors),
							type: card.type,
							mana_cost: card.mana_cost,
							cmc: card.cmc,
							count: count
						}
				card_detail_hash[card.name] = card_hash

				card_color_hash[card_hash[:color]] += count
				cc_hash[card.mana_cost] ? cc_hash[card.mana_cost] += count : cc_hash[card.mana_cost] = count

				cc_hash[card.cmc] ? cc_hash[card.cmc] += count : cc_hash[card.cmc] = count
			end
		end

		## Collect info from API

		@card_color_hash = card_color_hash
		@card_detail_hash = card_detail_hash
		@casting_cost_hash = cc_hash
	end

	def map_colors( colors )
		if colors.nil? || colors.empty?
			return "Colorless"
		elsif colors.size == 1
			return colors[0]
		else colors.size >  1
			return "Gold"
		end
	end

	def print_decklist
		puts @card_detail_hash
	end

	def count_cards
		count = 0
		@card_detail_hash.each do |key, value|
			count += value[:count].to_i
		end

		count
	end

	def list_duplicates
		duplicate_list = []
		@card_detail_hash.each do |key, value|
			duplicate_list.push value[:count].to_s +  ' ' + key + '\n' if value[:count].to_i > 1
		end

		duplicate_list.push 'No duplicates found.' if duplicate_list.empty?
		duplicate_list.join
	end

	def count_duplicates
		list_duplicates.size
	end

	def count_color(color)
		@card_color_hash[color]
	end


end
