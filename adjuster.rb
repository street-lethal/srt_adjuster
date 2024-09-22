require './config'

def add_offset(origin_time, offset_msec)
  hour, min, sec, msec = origin_time.split(/[:,]/)
  total_msec = ((hour.to_i * 60 + min.to_i) * 60 + sec.to_i) * 1000 + msec.to_i
  total_msec_with_offset = total_msec + offset_msec
  total_sec_with_offset, msec_with_offset = total_msec_with_offset.divmod(1000)
  total_min_with_offset, sec_with_offset = total_sec_with_offset.divmod(60)
  hour_with_offset, min_with_offset = total_min_with_offset.divmod(60)
  "#{format('%02d', hour_with_offset)}:#{format('%02d', min_with_offset)}:" +
    "#{format('%02d', sec_with_offset)},#{format('%03d', msec_with_offset)}"
end

time_format = '\d{2}:\d{2}:\d{2},\d{3}'
spliter = ' --> '
full_format = /#{time_format}#{spliter}#{time_format}/

File.readlines("srts/#{ORIGIN_FILENAME}").each do |line|
  next puts line unless line =~ full_format

  first, latter = line.slice(full_format).split(spliter)

  first_with_offset = add_offset(first, OFFSET_MILLISECONDS)
  latter_with_offset = add_offset(latter, OFFSET_MILLISECONDS)

  puts "#{first_with_offset} --> #{latter_with_offset}"
end
