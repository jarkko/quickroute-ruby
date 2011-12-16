require_relative 'quickroute'
@filename = "../2010-ankkurirastit.jpg"
qp = QuickrouteJpegParser.new(@filename, false)
LOGGER.debug qp.inspect
