#!/usr/bin/env ruby
require "yt"
require "time"

raise "Missing YT_API_KEY environment variable!" if ENV["YT_API_KEY"].nil?

def list_japanese_cm_videos(period = today)
  videos = Yt::Collections::Videos.new
  videos.where(
    q: "CM 動画",
    relevanceLanguage: "ja-JP",
    videoDuration: "short",
    order: "date",
    publishedAfter: period[:from],
    publishedBefore: period[:to],
  ).each do |v|
    puts "#{v.title} - https://www.youtube.com/watch?v=#{v.id}"
  end
end

private

def today
  from = Time.now.to_date.to_datetime.rfc3339
  now = Time.now.utc.to_datetime.rfc3339
  {:from => from, :to => now}
end

def this_month
  from = DateTime.parse("#{Time.now.utc.year}-#{Time.now.utc.month}-1 00:00:00").rfc3339
  now = Time.now.utc.to_datetime.rfc3339
  {:from => from, :to => now}
end

list_japanese_cm_videos(this_month)
