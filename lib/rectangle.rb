class Rectangle < BinData::Record
  endian :little
  uint16 :x
  uint16 :y
  uint16 :width
  uint16 :height
end
