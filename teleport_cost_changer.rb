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

  changed = false

  doc.xpath('//*[starts-with(@action, "bypass -h npc_%objectId%_goto")]').each do |a|
    content = a.content
    puts content

    # Search for numbers within content
    if content =~ /([\d]+) adena/i
      changed = true

      number = $1
      number = number.to_i
      new_number = number/15

      content = content.gsub(number.to_s, new_number.to_s)
      a.content = content
    end
  end

  if changed == true
    next
  end

  next

  changedContent = doc.to_html
  changedContent = changedContent.gsub('&amp;', '&')
  changedContent = changedContent.gsub('%20', ' ')

  new_file = File.new(f, 'w+')
  new_file.syswrite(changedContent)
  puts "#{f} Written"
end
