require_relative '../spec_helper'

describe "Parsing existing jpg file without calculation" do
  before(:all) do
    @filename = File.join(File.expand_path(File.dirname(__FILE__)),
                          '../fixtures/2010-Ankkurirastit.jpg')

    @qp = QuickrouteJpegParser.new(File.join(@filename), false)
  end

  it "should have correct version" do
    @qp.version.should == "1.0.0.0"
  end

  it "should have correct size in pixels" do
    @qp.map_location_and_size_in_pixels.width.should == 1365
    @qp.map_location_and_size_in_pixels.height.should == 1556
  end

  it "should have one session" do
    @qp.sessions.size.should equal(1)
  end

  describe "session" do
    before do
      @it = @qp.sessions.first
    end

    it "should have correct session info" do
      @it.session_info.person.name.should == "kari ja maria"
    end

    it "should have 17 laps" do
      @it.laps.size.should equal(17)
    end

    describe "lap" do
      it "should have correct time" do
        Time.at(@it.laps.first.time).to_s.should == "2010-04-18 11:48:03 +0300"
      end
    end

    it "should have 39 handles" do
      @it.handles.size.should equal(39)
    end

    it "should have correct projection origin" do
      @it.projection_origin.latitude.should == 60.33081694444444
      @it.projection_origin.longitude.should == 22.894455
    end

    describe "route" do
      it "should have one segment" do
        @it.route.segments.size.should equal(1)
      end

      describe "segment" do
        it "should have 1001 waypoints" do
          @it.route.segments.first.waypoints.size.should equal(1001)
        end

        describe "first waypoint" do
          before do
            @wp = @it.route.segments.first.waypoints.first
          end

          it "should have correct time set" do
            Time.at(@wp.time).to_s.should == "2010-04-18 11:48:03 +0300"
          end

          it "should have correct position" do
            @wp.position.latitude.should == 60.34066361111111
            @wp.position.longitude.should == 22.904983333333334
          end

          it "should have correct altitude" do
            @wp.altitude.should == 62
          end
        end
      end
    end
  end
end

describe "Parsing existing jpg file with calculation" do
  before(:all) do
    @filename = File.join(File.expand_path(File.dirname(__FILE__)),
                          '../fixtures/2010-Ankkurirastit.jpg')

    @qp = QuickrouteJpegParser.new(File.join(@filename), true)
  end

  describe "session" do
    it "should have correct straight line distance" do
      @qp.sessions.first.straight_line_distance.round.should == 6750
    end
  end

  describe "route" do
    it "should have correct distance" do
      @qp.sessions.first.route.distance.round.should == 7566
    end

    it "should have correct elapsed time" do
      @qp.sessions.first.route.elapsed_time.should == 2706.0
    end
  end
end
