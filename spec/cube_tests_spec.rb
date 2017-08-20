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


	# Tests beneath this are Integration Tests using a file
	describe "#new" do
		it "is a Cube" do
			expect(@cube.instance_of? Cube).to be true
		end
	end

	describe "#count_cards" do
		it "Should contain 36 cards" do
			expect(@cube.count_cards).to eq('36'.to_i)
		end
	end

	describe "#list_duplicates" do
		it "Should contain only singleton cards" do
			expect(@cube.list_duplicates).to eq('No duplicates found.')
		end
		it "Should display duplicate cards" do
			duplicate_card = @cube.card_detail_hash['Abrade']
			@cube.card_detail_hash['Abrade'][:count] = 4
			expect(@cube.list_duplicates).to eq("4 Abrade\n")
		end

	end


	it "Should contain 3 Blue cards" do
		expect(@cube.count_color('Blue')).to eq (6)
	end

	it "Should contain 6 Green cards" do
		expect(@cube.count_color('Green')).to eq (6)
	end

	it "Should contain 3 Colorless cards" do
		expect(@cube.count_color('Colorless')).to eq (3)
	end

	it "Should contain 3 Gold cards" do
		expect(@cube.count_color('Gold')).to eq (3)
	end

end
