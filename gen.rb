#!/usr/bin/env ruby

COUNTRIES_MAP = {
  'USA' => [30..60.0, -100.0..-80],
  'RUS' => [40..60.0, 50.0..150],
  'ESP' => [30..40.0, -10.0..0],
  'TUR' => [30..40.0, 30.0..40],
  'IND' => [10..30.0, 60.0..80],
}

raise 'size required' unless ARGV[0]
GROUP_SIZE = Integer(ARGV[0])

users = COUNTRIES_MAP.first(5).flat_map do |country, bounds|
  GROUP_SIZE.times.flat_map do |idx|
    result = {
      name: "#{country}#{idx}",
      nationality: country,
      lat: rand(bounds[0]),
      lon: rand(bounds[1]),
    }
    result
  end
end

users.each_slice(1000) do |batch|
  tuples_string = batch.map do |x|
    "\n('#{x[:name]}', '#{x[:nationality]}', #{x[:lat]}, #{x[:lon]})"
  end.join(', ')
  puts "INSERT INTO USERS(name, nationality, lat, lon) values #{tuples_string};"
end
