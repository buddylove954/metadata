require 'net/http'
require 'uri'
require 'nokogiri'
require 'logger'

# Set up a logger
log = Logger.new('fetch.log')

def fetch_and_save_url(url, log)
  uri = URI.parse(url)

  begin
    response = Net::HTTP.get_response(uri)
    if response.code == '200'
      content = response.body
      filename = File.basename(uri.host) + '.html'
      File.open(filename, 'w') { |file| file.write(content) }
      log.info("Saved: #{filename}")
      record_metadata(url, content, log)
    else
      log.error("Failed to fetch: #{url} (HTTP #{response.code})")
    end
  rescue StandardError => e
    log.error("An error occurred while fetching #{url}: #{e.message}")
  end
end

def record_metadata(url, content, log)
  doc = Nokogiri::HTML(content)
  num_links = doc.css('a').count
  num_images = doc.css('img').count

  metadata = {
    site: url,
    num_links: num_links,
    images: num_images,
    last_fetch: Time.now.strftime('%a %b %d %Y %H:%M %Z')
  }

  log.info("Metadata:")
  metadata.each { |key, value| log.info("#{key}: #{value}") }
end

def main(urls, metadata_flag, log)
  urls.each do |url|
    if metadata_flag
      begin
        response = Net::HTTP.get_response(URI.parse(url))
        record_metadata(url, response.body, log)
      rescue StandardError => e
        log.error("An error occurred while fetching #{url} for metadata: #{e.message}")
      end
    else
      fetch_and_save_url(url, log)
    end
  end
end

if ARGV.empty?
  puts 'Usage: ruby fetch.rb [--metadata] URL1 [URL2 URL3 ...]'
  exit(1)
end

metadata_flag = ARGV[0] == '--metadata'
start_index = metadata_flag ? 1 : 0
urls = ARGV[start_index..-1]

main(urls, metadata_flag, log)


