require_relative '../spec_helper'

describe Waypoint do
  before(:each) do
    @route = Route.new
    @segment = stub(:segment, :route => @route)
    @position = LongLat.new(0,0)
    LongLat.stub(:from_data).and_return(@position)
    @it = Waypoint.new(@segment)
  end

  it "should have a zero distance" do
    @it.distance.should == 0
  end

  it "should be able to set elapsed time" do
    @it.elapsed_time = 180
    @it.elapsed_time.should == 180
  end

  describe "#distance_to" do
    it "should delegate to position" do
      @other = Waypoint.new(@segment)
      @op = LongLat.new(0,1)
      @other.position = @op
      @it.position = @position
      @position.should_receive(:distance_to).with(@op).and_return(50)
      @it.distance_to(@other).should == 50
    end
  end
end

