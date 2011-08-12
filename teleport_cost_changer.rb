require 'nokogiri'

files = Dir.entries(Dir.pwd)

files.each do |file|
  files.delete(file) unless file.end_with?('.htm')
end

files.each do |f|
  doc = Nokogiri::HTML(open(f))

  doc.xpath('//*[starts-with(@action, "bypass -h npc_%objectId%_goto")]').each do |a|
    content = a.content

    # Search for numbers within content
    if content =~ /([\d]+) Adena/i
      number = $1
      number = number.to_i
      new_number = number/15

      content = content.gsub(number.to_s, new_number.to_s)
      a.content = content
    end
  end

  new_file = File.new(f, 'w+')
  new_file.syswrite(doc.to_html)
end
