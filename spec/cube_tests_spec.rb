require 'spec_helper'
require 'cube'

describe Cube do
	before :all do
	    @cube = Cube.new("test_cardlist.txt")
	end

	describe "#new" do
		it "is a Cube" do
			expect(@cube.instance_of? Cube).to be true
		end
	end

	it "Should contain 360 cards" do
		expect(@cube.count_cards).to eq('360'.to_i)
	end

	it "Should contain only singleton cards" do
		expect(@cube.list_duplicates).to eq('No duplicates found.')
	end

	it "Should contain 60 green cards" do
		expect(@cube.count_color('Green')).to eq (60)
	end

	it "Should identify gold and colorless cards" do
		expect(@cube.map_colors(["Green"])).to eq "Green"
		expect(@cube.map_colors(["Green", "Red"])).to eq "Gold"
		expect(@cube.map_colors(nil)).to eq "Colorless"
		expect(@cube.map_colors([])).to eq "Colorless"
	end

	#TODO: Test for leading card numbers in card list
end
