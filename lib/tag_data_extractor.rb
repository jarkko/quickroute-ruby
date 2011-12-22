class TagDataExtractor < BinData::Record
  endian  :little
  uint8be :tag
  uint32  :data_length
end
