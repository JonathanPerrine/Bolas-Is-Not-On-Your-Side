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
		File.open(filename) {|f| count = f.read.count("\n")}
	end


end
