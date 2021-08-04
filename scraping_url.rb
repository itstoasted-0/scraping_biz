require 'open-uri'
require 'nokogiri'
require 'pry'

urls = []
(1..220).each do |i|
  url = "https://biz-maps.com/search?city%5B0%5D=072036&page=#{i}"
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  charset = nil
  html = URI.open(url, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)
  doc.at_css('div.resultsWrapper ul').css('a').each do |row|
    urls << "https://biz-maps.com#{row.attribute('href').value}"
  end
  sleep(8.0)
end


#txt書き出し

if File.exist?("url-data.txt")
  File.delete("url-data.txt")
end

urls.each do |url|
  File.open("url-data.txt","a") do |f|
    f.puts url
  end
end

p "出力完了"