require 'json'
require 'open-uri'
require 'pathname'
module Xkcdx
  DATA_PATH = Pathname.new File.expand_path('../../data', __FILE__)

  def self.pack
    files = Dir.glob(DATA_PATH.join('fetched', '*.json'))
    puts "Data files: #{files.count}"
    data = files.inject([]) do |arr, j|
      d = open(j){|f| JSON.parse f.read }
      arr << d
    end

    open(DATA_PATH.join('xkcds.json'), 'w'){|f| f.write JSON.pretty_generate data}
  end

  def self.scrape_images
    img_path = DATA_PATH.join('images').tap{|d| d.mkpath }
    Dir.glob(DATA_PATH.join('fetched', '*.json')).each_with_index do |j, idx|
      d = JSON.parse open(j){|x| x.read }
      fname = img_path.join("#{d['num']}.json")
      if fname.exist?
        puts "#{idx}: ##{d['img']} already fetched"
      else
        puts "#{idx}: Fetching #{d['img']}"
        open(fname, 'wb'){|f| f.write open(d['img']){|x| x.read }}
        sleep 1
      end
    end
  end

  def self.scrape
    path = DATA_PATH.join('fetched').tap{|d| d.mkpath}
    # get latest_comic
    latest = open('http://xkcd.com/info.0.json'){|x| x.read }
    latest_num = JSON.parse(latest)['num'].to_i
    (1..latest_num).each do |i|
      fname = path.join("#{i}.json")
      unless fname.exist?
        puts "Fetching #{i}"
        begin
          data = latest_num == i ? latest : open("http://xkcd.com/#{i}/info.0.json"){|x| x.read } # yes, a wasteful branch, oh well
        rescue HTTPError => err
          puts "#{i}: #{err}"
        else
          open(fname, 'w'){|w| w.write data}
          sleep 1 if rand(5) == 0
        end
      else
        puts "Already have #{i}"
      end
    end
  end
end
