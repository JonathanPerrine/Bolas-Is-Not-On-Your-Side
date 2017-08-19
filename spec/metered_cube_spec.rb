require 'spec_helper'
require 'metered_cube'

CARDLIST = 'happy_cube.txt'

describe MeteredCube do

	before :all do
	    @metered_cube = MeteredCube.new(CARDLIST)
	end

  describe "#new" do
		it "is a Metered Cube" do
			expect(@metered_cube.class).to eq MeteredCube
		end
	end

  describe "#show_color_balance" do
    it "returns the color delta hash" do
      @metered_cube.set_color_targets({"White" => 6, "Blue" => 6, "Black" => 6, "Red" => 6, "Green" => 6, "Gold" => 3, "Colorless" => 3})
      expect(@metered_cube.show_color_balance).to eq({ "White" => 0, "Blue" => 0, "Black" => 0, "Red" => 0, "Green" => 0, "Colorless" => 0, "Total" => 36})
      expect(@metered_cube.show_color_balance_total).to eq(36)
    end
  end

end
