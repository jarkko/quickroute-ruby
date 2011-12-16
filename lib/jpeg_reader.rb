module JpegReader
  def self.fetch_data_from(filename)
    data = ""

    File.open(filename, "r") do |f|
      if f.read(2) == "\xff\xd8".to_b
        while !f.eof?
          break if f.read(1) != "\xff".to_b

          if f.read(1) == "\xe0".to_b # APP0
            quickroute_segment = false
            length = BinData::Uint16be.read(f)

            if length >= 12
              if f.read(10) == "QuickRoute".to_b
                data << f.read(length - 12)
                quickroute_segment = true
              else
                f.seek(length - 12, ::IO::SEEK_CUR)
              end
            else
              f.seek(length - 2, ::IO::SEEK_CUR)
            end

            break if !quickroute_segment && !data.empty?
          else
            break
          end
        end
      end
    end

    data
  end
end
