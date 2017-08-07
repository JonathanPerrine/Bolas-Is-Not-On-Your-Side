class Cube

	DeckListName = "decklist.txt"
	@decklist

	def load_decklist_from_text (filename = DeckListName)
		file = File.open(filename, "r")
		@decklist = file.read

	end

	def print_decklist
		puts @decklist
	end

	def count_cards(filename = DeckListName)
		count = 0
		File.open(filename, 'r') do |file|
			file.each_line do |file_line|
				count += file_line[/\d+/].to_i
			end
		end
		count
	end


end
