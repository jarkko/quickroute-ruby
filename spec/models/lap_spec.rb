require_relative '../spec_helper'

describe Lap do
  before(:each) do
    @it = Lap.new
  end

  describe "setting position" do
    it "should set the position ivar and be readable" do
      long_lat = LongLat.new(0,0)
      @it.position = long_lat

      @it.position.should == long_lat
    end 
  end

  describe "setting distance" do
    it "should work" do
      @it.distance = 69
      @it.distance.should == 69
    end
  end

  describe "setting straight line distance" do
    it "should work" do
      @it.straight_line_distance = 69
      @it.straight_line_distance.should == 69
    end
  end
end
