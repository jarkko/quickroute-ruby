require 'rubygems'
require 'bindata'
require_relative 'long_lat'
require_relative 'rectangle'
require_relative 'quickroute_jpeg_parser'

@filename = "../2010-ankkurirastit.jpg"
@f = File.open(@filename, 'r')
