require 'spec_helper'
require 'cube'

describe Cube do
	before :each do
	    @cube = Cube.new
	end

	describe "#new" do
		it "is a Cube" do
			expect(@cube.instance_of? Cube).to be true
		end
	end

	it "Should contain 360 cards" do
		@cube.load_decklist_from_text
		expect(@cube.count_cards).to eq('360'.to_i)
		puts @cube.count_cards
	end
end