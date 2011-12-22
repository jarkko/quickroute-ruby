require_relative '../spec_helper'

describe Session do
  before(:each) do
    @it = Session.new
    @it.route = @route = Route.new
  end

  describe "calculate" do
    it "should call route.calculate" do
      @route.should_receive(:calculate_parameters)
      @it.calculate
    end
  end
end
