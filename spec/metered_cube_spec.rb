require 'spec_helper'
require 'metered_cube'

CARDLIST = test_cardlist.txt

describe MeteredCube do

	before :all do
	    @metered_cube = Cube.new(CARDLIST)
	end
  
  describe "#new" do
		it "is a Metered Cube" do
			expect(@metered_cube.instance_of? MeteredCube).to be true
		end
	end
  
  describe "#measure_color_balance" do
    it "returns the color delta hash" do
      @metered_cube.set_color_targets({"White" => 60, "Blue" => 60, "Black" => 60, "Red" => 60, "Green" => 60, "Colorless" => 60})
      expect(@metered_cube.measure_color_balance.to eq({ "White" => -5, "Blue" => 10, "Black" => 0, "Red" => 20, "Green" => 0, "Colorless" => 0})
      expect(@metered_cube.measure_color_balance_total.to eq(30)
    end
  
end
