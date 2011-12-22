require_relative '../spec_helper'

describe QuickrouteJpegParser do
  describe '#new' do
    describe 'with calculate == false' do
      it "should not calculate values" do
        #TagDataExtractor.stub!(:extract_tag_data).and_return([5, 16])
        JpegReader.stub!(:fetch_data_from).and_return("")
        @session = Session.new
        Session.stub!(:read_sessions).and_return([@session])
        @session.should_not_receive(:calculate)
        @parser = QuickrouteJpegParser.new("filename", false)
      end
    end
  end
end
