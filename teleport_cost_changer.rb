require 'nokogiri'

files = Dir.entries(Dir.pwd)

files.each do |file|
  files.delete(file) unless file.end_with?('.htm')
end

changes = Array.new

files.each do |f|
  unless f.end_with?('.htm')
    next
  end

  doc = Nokogiri::HTML(open(f))

  count = 0

  doc.xpath('//*[starts-with(@action, "bypass -h npc_%objectId%_goto")]').each do |a|
    content = a.content

    # Search for numbers within content
    if content =~ /([\d]+) adena/
      number = $1
      number = number.to_i
      new_number = number/15

      content = content.gsub(number.to_s, new_number.to_s)
      a.content = content
      count = count + 1
    end
  end

  if count == 0
    next
  end

  changedContent = doc.to_html
  changedContent = changedContent.gsub('&amp;', '&')
  changedContent = changedContent.gsub('%20', ' ')

  new_file = File.new(f, 'w+')
  new_file.syswrite(changedContent)
  puts "#{f} Written"
end
