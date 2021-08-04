require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'csv'
require 'pry'

opt = {}
opt['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36'

arr = []

random = Random.new
i = 0

File.open('url-data.txt') do |f|
    f.each_line do |line|
        line.chomp!
        doc = Nokogiri::HTML(URI.open(line, opt))
        company_name = doc.xpath('//*[@id="main"]/div[1]/div[1]/h1').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")
        company_text = doc.xpath('//*[@id="main"]/div[1]/div[1]/div/div/p/text()').text
        postal_code = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[1]/table/tr[1]/td/text()[1]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")
        address = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[1]/table/tr[1]/td/text()[2]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 
        established = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[1]/table/tr[2]/td/text()').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 
        capital = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[1]/table/tr[3]/td/text()').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 
        representative = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[1]/table/tr[4]/td/text()').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 
        url = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[1]/table/tr[5]/td/a').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 
        sales = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[2]/div/div[1]/span[2]/text()').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 
        employee = doc.xpath('//*[@id="main"]/div[1]/div[1]/section[1]/div/div[2]/div/div[2]/span[2]/text()').text.gsub(/(\r\n|\r|\n|\f|\t)/, "") 

        arr << [company_name, company_text, postal_code, address, established, capital, representative, url, sales, employee]
 
        sleep(random.rand(12.0)+8) #8〜20秒待つ
        i += 1
        p "input data (#{i})"

    end
end


#CSV出力
headers = ["会社名", "概要", "郵便番号", "住所", "設立年度", "資本金等","代表者", "URL", "売上", "従業員数"]

CSV.open('output.csv', 'w') do |csv|
    csv << headers
    arr.each do |d|
        csv << d
    end
end