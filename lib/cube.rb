require "mtg_sdk"
require 'json'

class Cube

	DefaultCardListName = "cardlist.txt"
	@decklist

	def load_decklist_from_text (filename = DefaultCardListName)
		card_array = []
		cardlist = File.open(filename, "r").read

		card_list_hash = {}
		cardlist.each_line do |line|
			card_name = line.match(/\s(.*)$/)[1]
			card_array << card_name
			card_list_hash[card_name] = {count: line.match(/\A(\d+)/)[1]}
		end

		card_detail_hash = {}

		card_detail_hash = {}
		card_array.each_slice(100) do |cards|
			MTG::Card.where(name: cards.join("|")).all.each do |card|
				card_hash = {color: card.colors[0], type: card.type, mana_cost: card.mana_cost, cmc: card.cmc}
				card_detail_hash[card.name] = card_hash
			end
		end

		card_list_hash.merge(card_detail_hash)

		## Collect info from API

		@decklist = card_list_hash
	end

	def print_decklist
		puts @decklist
	end

	def count_cards
		count = 0
		@decklist.each do |key, value|
			count += value[:count].to_i
		end

		count
	end

	def list_duplicates
		duplicate_list = []
		@decklist.each do |key, value|
			duplicate_list.push value[:count].to_s +  ' ' + key + '\n' if value[:count].to_i > 1
		end

		duplicate.push 'No duplicates found.' if duplicate_list.empty?
		duplicate_list.join
	end

	def count_color(color)
		color_count = 0
		@decklist.each do |key, value|
			color_count += value[:count].to_i if value[:color].to_s.eql? color.to_s
		end
		color_count.to_i
	end


end
