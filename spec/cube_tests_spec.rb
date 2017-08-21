require 'spec_helper'
require 'cube'

describe Cube do
	before :all do
	    @cube = Cube.new("happy_cube.txt")
	end


	# Test beneath this are Unit Tests

	describe "#map_colors" do
		it "Should identify Green cards" do
			expect(@cube.map_colors(["Green"])).to eq "Green"
		end
		it "Should identify Gold cards" do
			expect(@cube.map_colors(["Green", "Red"])).to eq "Gold"
		end
		it "Should identify Colorless cards" do
			expect(@cube.map_colors(nil)).to eq "Colorless"
		end
	end

	describe "#load_cardlist_from_text" do
		it "Should create a hash of cards" do
			cardlist_hash = @cube.load_cardlist_from_text("happy_cube.txt")
			expect(cardlist_hash.keys).to match_array ["Abrade","Accursed Horde","Act of Heroism","Adorned Pouncer","Ancient Crab","Anointed Procession","Anointer Priest","Aven Initiate","Aven of Enduring Hope","Aven Reedstalker","Aven Wind Guide","Baleful Ammit","Banewhip Punisher","Binding Mummy","Bitterblade Warrior","Bitterbow Sharpshooters","Blazing Volley","Bloodlust Inciter","Bloodwater Entity","Blur of Blades","Bone Picker","Bontu's Last Reckoning","Bontu's Monument","Brute Strength","Burning-Fist Minotaur","Cancel","Carrion Screecher","Cartouche of Knowledge","Cartouche of Strength","Censor","Channeler Initiate","Colossapede","Cradle of the Accursed","Crypt of the Eternals","Decimator Beetle","Dissenter's Deliverance"]
		end
	end

	describe "#generate_card_detail_hash" do
		it "Should get details for a single card" do
			detail_hash = @cube.generate_card_detail_hash({"Abrade" => 1})
			detail_hash['Abrade'][:color] = 'Red'
			detail_hash['Abrade'][:type] = 'Instant'
			detail_hash['Abrade'][:mana_cost] = '{1}{R}'
			detail_hash['Abrade'][:cmc] = 2
			detail_hash['Abrade'][:count] = 1
		end
		it "Should get details for a multiple cards" do
			detail_hash = @cube.generate_card_detail_hash({"Abrade" => 1, "Bitterbow Sharpshooters" => 2, "Cancel" => 4})
			detail_hash['Abrade'][:color] = 'Red'
			detail_hash['Abrade'][:count] = 1
			detail_hash['Bitterbow Sharpshooters'][:color] = 'Green'
			detail_hash['Bitterbow Sharpshooters'][:count] = 2
			detail_hash['Cancel'][:color] = 'Blue'
			detail_hash['Cancel'][:count] = 4
		end
	end

	describe "#Generate_card_color_hash" do

		before :all do
			detail_hash = @cube.generate_card_detail_hash({"Bitterbow Sharpshooters" => 6, "Cancel" => 6, "Crypt of the Eternals" => 3, "Decimator Beetle" => 3})
			@card_color_hash = @cube.generate_card_color_hash(detail_hash)
		end

		it "Should contain 6 Blue cards" do
			expect(@card_color_hash['Blue']).to eq (6)
		end

		it "Should contain 6 Green cards" do
			expect(@card_color_hash['Green']).to eq (6)
		end

		it "Should contain 3 Colorless cards" do
			expect(@card_color_hash['Colorless']).to eq (3)
		end

		it "Should contain 3 Gold cards" do
			expect(@card_color_hash['Gold']).to eq (3)
		end
	end

	describe "#show_duplicates / #count_duplicates" do
		it "Should contain only singleton cards" do
			detail_hash = @cube.generate_card_detail_hash({"Abrade" => 1, "Bitterbow Sharpshooters" => 1, "Cancel" => 1})
			expect(@cube.show_duplicates(detail_hash)).to eq('No duplicates found.')
		end
		it "Should display duplicate cards" do
			detail_hash = @cube.generate_card_detail_hash({"Abrade" => 4, "Bitterbow Sharpshooters" => 2, "Cancel" => 1})
			expect(@cube.show_duplicates(detail_hash)).to eq("4 Abrade\n2 Bitterbow Sharpshooters")
		end
		it "Scould display a correct card count" do
			detail_hash = @cube.generate_card_detail_hash({"Abrade" => 4, "Bitterbow Sharpshooters" => 2, "Cancel" => 1})
			expect(@cube.count_duplicates(detail_hash)).to eq( 6 )
		end
	end


	# Tests beneath this are Integration Tests using a file
	describe "#new" do
		it "is a Cube" do
			@cube = Cube.new("happy_cube.txt")
			expect(@cube.instance_of? Cube).to be true
		end
	end

	describe "#count_cards" do
		it "Should contain 36 cards" do
			@cube = Cube.new("happy_cube.txt")
			expect(@cube.count_cards(@cube.card_detail_hash)).to eq('36'.to_i)
		end
	end

end
