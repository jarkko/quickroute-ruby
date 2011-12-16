module TagDataExtractor
  def extract_tag_data(data)
    tag = BinData::Uint8be.read(data)
    tag_data_length = BinData::Uint32le.read(data)

    [tag, tag_data_length]
  end
end
