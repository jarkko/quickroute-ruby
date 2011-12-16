module DateTimeParser
  def read_date_time(data)
    val = BinData::Uint64le.read(data)
    puts "val is #{val.inspect}"
    val -= 9223372036854775808 if val >= 9223372036854775808
    val -= 4611686018427387904 if val >= 4611686018427387904
    puts "after tweaks val is #{val.inspect}"
    val = (val - 621355968000000000) / 10000000
    puts "time was #{Time.at(val)}"
    val
  end
end
