$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'xkcdx'

namespace :x do
  desc 'pack stuff'
  task :pack do
    Xkcdx.pack
  end

  desc 'scrape images'
  task :scrape_images do
    Xkcdx.scrape_images
  end

  desc 'create thumbs'
  task :create_thumbs do
    Xkcdx.create_thumbs
  end
end
