require_relative '../spec_helper'

describe RouteSegment do
  before(:each) do
    @route = Route.new
    @it = RouteSegment.new(@route)
    @wp1 = Waypoint.new(@it)
    @wp2 = Waypoint.new(@it)
    @wp3 = Waypoint.new(@it)
  end

  describe "#add_waypoints" do
    it "should add waypoints to the segment" do
      @it.add_waypoint(@wp1, @wp2, @wp3)
      @it.waypoints.should == [@wp1, @wp2, @wp3]
    end
  end

  describe "#calculate_waypoints" do
    before(:each) do
      @it.add_waypoint(@wp1, @wp2, @wp3)
      @wp2.should_receive(:distance_to).with(@wp1).and_return(10)
      @wp3.should_receive(:distance_to).with(@wp2).and_return(20)

      t1 = Time.now.to_i
      @wp1.should_receive(:time).at_least(:once).and_return(t1)
      @wp2.should_receive(:time).at_least(:once).and_return(t1 + 60)
      @wp3.should_receive(:time).at_least(:once).and_return(t1 + 180)

      @it.calculate_waypoints
    end

    it "should calculate the total distance for each waypoint" do
      @wp1.distance.should == 0
      @wp2.distance.should == 10
      @wp3.distance.should == 30
    end

    it "should calculate the total elapsed time for each waypoint" do
      @wp1.elapsed_time.should == 0
      @wp2.elapsed_time.should == 60
      @wp3.elapsed_time.should == 180
    end

    it "should update route's distance and time in the end" do
      @route.distance.should == 30
      @route.elapsed_time == 180
    end
  end
end
