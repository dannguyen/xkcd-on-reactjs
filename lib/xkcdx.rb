require 'json'
require 'open-uri'
require 'pathname'
require 'mini_magick'

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

  def self.create_thumbs(w=200,h=200)
    tpath = DATA_PATH.join('thumbs').tap{|t| t.mkpath }
    files = Dir.glob(DATA_PATH.join('images', '*.*'))
    files.each do |fname|
      thumb = fit_and_resize_image(fname, w, h)
      # write only jpgs
      thumb.write(tpath.join(File.basename(fname)[/\d+/] + '.jpg'))
    end
  end


  def self.scrape_images
    img_path = DATA_PATH.join('images').tap{|d| d.mkpath }
    Dir.glob(DATA_PATH.join('fetched', '*.json')).each_with_index do |j, idx|
      d = JSON.parse open(j){|x| x.read }
      fname = img_path.join("#{d['num']}#{File.extname d['img']}")
      if fname.exist?
        puts "#{idx}: ##{d['img']} already fetched"
      else
        puts "#{idx}: Fetching #{d['img']}"
        open(fname, 'wb'){|f| f.write open(d['img']){|x| x.read }}
        puts "Saving to #{fname}"
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


  # returns a MiniMagick::Image object
  def self.fit_and_resize_image(img_path, fw, fh)
    image = MiniMagick::Image.open(img_path)
    w = image[:width].to_f
    h = image[:height].to_f

    # long image into long image (or square)
    if w >= h && fw >= fh
      nw = fw
      nh = h * (fw / w)
    # long image into tall image
    elsif w >= h && fw < fh
      nw = fw
      nh = h * (fw / w)
    # tall image into tall image
    elsif w < h && fw < fh
      nh = fh
      nw = w * (fh / h)
    # tall image into wide image
    elsif w < h && fw >= fh
      nh = fh
      nw = w * (fh / h)
    end
    image.combine_options do |i|
      i.resize "#{nw.floor}x#{nh.floor}"
      i.gravity(:center)
      i.extent "#{fw}x#{fh}"
      i.quality 70
    end

    return image
  end
end
