#!/usr/bin/env ruby
require "yt"

raise "Please obtain me your YT_API_KEY environment variable!" if ENV["YT_API_KEY"].nil?

videos = Yt::Collections::Videos.new
videos.where(q: "CM 動画", relevanceLanguage: "ja-JP", videoDuration: "short", order: "date").each do |v|
  puts "#{v.title} - https://www.youtube.com/watch?v=#{v.id}"
end
