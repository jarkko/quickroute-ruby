require 'rubygems'
require 'bindata'
require_relative 'tag_data_extractor'
require_relative 'date_time_parser'
require_relative 'handle'
require_relative 'point'
require_relative 'parameterized_location'
require_relative 'lap'
require_relative 'person'
require_relative 'route'
require_relative 'route_segment'
require_relative 'session'
require_relative 'session_info'
require_relative 'waypoint'

require_relative 'long_lat'
require_relative 'rectangle'
require_relative 'quickroute_jpeg_parser'

@filename = "../2010-ankkurirastit.jpg"
@f = File.open(@filename, 'r')
