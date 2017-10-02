require 'json'
require 'net/https'

APP_ID     = "ABC"
APP_SECRET = "DEF"
OUTPUT_FILE = "data.txt"

urls = %w(https://www.facebook.com/nghia.truong.106902
https://www.facebook.com/kyle.n.307
https://www.facebook.com/hienmv.vns)

@result = ""

def get_info url
  begin
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONEs
    res = http.request(Net::HTTP::Get.new("#{uri.request_uri}?access_token=#{@token}&fields=name,age_range,birthday,picture"))
    contents = JSON.parse(res.body)
    puts JSON.pretty_generate(contents)
    @result += "#{contents["name"]}\n"
  rescue => e
    STDERR.puts "[ERROR][#{self.class.name}.get_info] #{e}"
    exit 1
  end
end

@token = ACCESS_TOKEN

urls.each do |url|
  a =  `curl -v #{url} 2>&1 |  grep -o \'entity_id.*]\' | cut -c 1-30`
  uid = a.to_s.scan(/(\d+)/).flatten.first
  url_base   = "https://graph.facebook.com/#{uid}"
  get_info url_base
end

File.open(OUTPUT_FILE, "w+") do |file|
  file.write @result
end
