require "mtg_sdk"
require 'json'
require 'deep_merge'

class Cube
	attr_accessor :card_detail_hash

	DefaultCardListName = "cardlist.txt"
	@cardlist_hash
	@card_detail_hash

	@card_color_hash
	@casting_cost_hash
	@duplicate_card_hash

	def initialize(filename = DefaultCardListName)
		@cardlist_hash = load_cardlist_from_text(filename)
		@card_detail_hash = generate_card_detail_hash(@cardlist_hash)

	end

	def load_cardlist_from_text (filename)
		cardlist = File.open(filename, "r").read

		cardlist_hash = {}

		cardlist.each_line do |line|
			card_name = line.match(/\s(.*)$/)[1]
			card_count = line.match(/\A(\d+)/)[1]
			cardlist_hash[card_name] = card_count
		end
		cardlist_hash
	end


	def generate_card_detail_hash(cardlist_hash)

		cost_hash = {}
		card_detail_hash = {}

		cardlist_hash.keys.each_slice(100) do |cards|
			MTG::Card.where(name: cards.join("|")).all.each do |card|
				if card_detail_hash[card.name].nil?
					count = cardlist_hash[card.name].to_i

					card_hash = {color: map_colors(card.colors),
								type: card.type,
								mana_cost: card.mana_cost,
								cmc: card.cmc,
								count: count
							}
					card_detail_hash[card.name] = card_hash

					cost_hash[card.mana_cost] ? cost_hash[card.mana_cost] += count : cost_hash[card.mana_cost] = count
					cost_hash[card.cmc] ? cost_hash[card.cmc] += count : cost_hash[card.cmc] = count
				end
			end
		end

		## Collect info from API

		@casting_cost_hash = cost_hash
		@card_detail_hash = card_detail_hash
	end

	def generate_card_color_hash(card_detail_hash)
		card_color_hash = {"White" => 0, "Blue" => 0, "Black" => 0, "Red" => 0, "Green" => 0, "Gold" => 0, "Colorless" => 0}
		card_detail_hash.each do |card_name, details|
			card_color_hash[details[:color].to_s] += details[:count].to_i
		end
		card_color_hash
	end


	def count_colors(card_detail_hash)
		generate_card_color_hash(card_detail_hash)
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

	def count_cards(card_detail_hash)
		count = 0
		card_detail_hash.each do |key, value|
			count += value[:count].to_i
		end
		count
	end

	def show_duplicates(card_detail_hash)
		duplicate_list = []
		card_detail_hash.each do |card_name, value|
			copies = value[:count].to_i
			duplicate_list.push copies.to_s +  ' ' + card_name if copies > 1
		end
		duplicate_list.push 'No duplicates found.' if duplicate_list.empty?
		duplicate_list.join("\n")
	end

	def count_duplicates(card_detail_hash)
		dupes = 0
		card_detail_hash.each do |card_name, value|
			copies = value[:count].to_i
			dupes += copies if copies.to_i > 1
		end
		dupes

	end



end
