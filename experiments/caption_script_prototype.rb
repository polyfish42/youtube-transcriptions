require 'strscan'
require 'net/http'
require 'open-uri'
require 'json'
require 'nokogiri'
require 'active_support/all'

res = Net::HTTP.get_response(URI("https://www.youtube.com/watch?v=7uUl_aTbOzQ&t=2s"))

s = StringScanner.new(res.body)

s.skip_until(/captionTracks\\":\[\{\\"baseUrl\\":\\"/)
uri = s.scan_until(/,/)
uri.gsub!(/\\\\u0026/, "&").gsub!(/\\/, "").chomp!("\",")

def remove_tags(str)
    result = ""
    in_tag = false

    str.chars.each do |s|
        if s == ">"
            in_tag = false
        elsif in_tag
            next
        elsif s == "<"
            in_tag = true
        else
            result += s
        end
    end
    result
end

doc = Nokogiri::HTML(open(uri))
doc.xpath("//transcript").children.each do |text|
    p text.attributes["dur"].value
    p remove_tags(text.children.inner_text)
end