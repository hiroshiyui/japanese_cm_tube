#!/usr/bin/env ruby
require "yt"
require "time"
require "active_support/core_ext"
require "csv"
require_relative "helper_logger"

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
    csv << ["id", "title", "url", "description", "channel_id", "channel_title", "channel_url"]
    videos.each do |v|
      v_detail = Yt::Collections::Videos.new.where(id: v.id).first
      csv << [v.id, v.title, video_url(v.id), v_detail.description, v_detail.channel_id, v_detail.channel_title, v_detail.channel_url]
      @logger.info("Saving: #{v.title} - #{video_url(v.id)}")
      sleep 1
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

def last_month
  from = Time.now.utc.last_month.beginning_of_month.rfc3339
  to = Time.now.utc.last_month.end_of_month.rfc3339
  {:from => from, :to => to}
end

def video_url(id)
  "https://www.youtube.com/watch?v=#{id}"
end

# main
begin
  @logger = logger
  @logger.info("Start saving video list...")

  if ARGV.empty?
    save_japanese_cm_videos
  else
    case ARGV.first
    when "last_month"
      save_japanese_cm_videos(last_month)
    end
  end
rescue => err
  @logger.fatal("Oops! There is something wrong!")
  @logger.fatal(err)
end
