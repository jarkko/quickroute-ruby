require_relative '../spec_helper'

describe Route do
  before(:each) do
    @it = Route.new
  end

  describe "#calculate_parameters" do
    before(:each) do
      @segment = stub
      @it.stub(:segments).and_return([@segment])
    end

    it "should calculate total distance for each segment" do
      @segment.should_receive(:calculate_waypoints)
      @it.calculate_parameters
    end
  end

  describe "#add_distance" do
    it "should add given distance" do
      @it.distance.should == 0
      @it.add_distance(180)
      @it.distance.should == 180
    end
  end

  describe "#add_elapsed_time" do
    it "should add given elapsed time" do
      @it.elapsed_time.should == 0
      @it.add_elapsed_time(180)
      @it.elapsed_time.should == 180
    end
  end
end
