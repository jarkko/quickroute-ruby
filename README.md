# QuickRoute JPEG Parser for Ruby

Parses the GPS data embedded to JPEG files output by [QuickRoute](http://www.matstroeng.se/quickroute/en/).

&copy; Jarkko Laine 2011. Licensed under the [WTFPL](http://en.wikipedia.org/wiki/WTFPL).

## Installation

    gem install quickroute


**Note!** Only works in Ruby >=1.9.2

## Usage

```ruby
@filename = '2010-silja-rastit.jpg'
qp = QuickrouteJpegParser.new(@filename, true) # true => calculates
times and distances.
qp.sessions.first.route.elapsed_time / 60
# => 43.766666666666666
qp.sessions.first.route.segments.first.waypoints.size
# => 992
qp.sessions.first.route.segments.first.waypoints.map{|wp| [wp.position.longitude, wp.position.latitude]}
# => [[22.78103777777778, 60.29233194444444], 
#     ...
#     [22.77652638888889, 60.293416388888886],
#     [22.77655638888889, 60.29344361111111]]
```
