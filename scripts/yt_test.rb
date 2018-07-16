#!/usr/bin/env ruby
require "yt"
require "time"
require "csv"

raise "Missing YT_API_KEY environment variable!" if ENV["YT_API_KEY"].nil?

def get_japanese_cm_videos(period = today)
  videos = Yt::Collections::Videos.new
  videos.where(
    q: "CM 動画",
    relevanceLanguage: "ja-JP",
    videoDuration: "short",
    order: "date",
    publishedAfter: period[:from],
    publishedBefore: period[:to],
  )
end

def save_japanese_cm_videos(period = today)
  videos = get_japanese_cm_videos(period)

  CSV.open("#{period[:from]}_#{period[:to]}.csv", "wb", :force_quotes => true) do |csv|
    csv << ["title", "url"]
    videos.each do |v|
      csv << [v.title, video_url(v.id)]
      puts "#{v.title} - #{video_url(v.id)}"
    end
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

def video_url(id)
  "https://www.youtube.com/watch?v=#{id}"
end

save_japanese_cm_videos
