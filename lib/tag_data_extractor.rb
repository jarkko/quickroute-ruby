module TagDataExtractor
  def extract_tag_data(data, pos)
    tag = BinData::Uint8be.read(data[pos,1])
    pos.inc
    tag_data_length = BinData::Uint32le.read(data[pos, 4])
    pos.inc 4
    tag_data = data[pos, tag_data_length]
    pos += tag_data_length

    [tag, tag_data, tag_data_length, pos]
  end
end
