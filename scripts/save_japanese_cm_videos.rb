#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yt'
require 'time'
require 'active_support/core_ext'
require 'csv'
require_relative 'helper_logger'

raise 'Missing YT_API_KEY environment variable!' if ENV['YT_API_KEY'].nil?

def get_japanese_cm_videos(period = today)
  videos = Yt::Collections::Videos.new
  videos.where(
    q: 'CM',
    relevanceLanguage: 'ja-JP',
    videoDuration: 'short',
    order: 'date',
    publishedAfter: period[:from],
    publishedBefore: period[:to]
  )
end

def save_japanese_cm_videos(period = today)
  videos = get_japanese_cm_videos(period)

  CSV.open("#{Time.now.to_i}.csv", 'wb', force_quotes: true) do |csv|
    # header
    csv << %w[
      id
      title
      published_at
      url
      description
      view_count
      like_count
      channel_id
      channel_title
      channel_url
      channel_description
      be_excluded
    ]

    # data
    videos.each do |v|
      v_detail = Yt::Video.new id: v.id
      channel = Yt::Channel.new id: v_detail.channel_id

      csv << [
        v.id,
        v.title,
        v.published_at,
        video_url(v.id),
        v_detail.description,
        v_detail.view_count,
        v_detail.like_count,
        v_detail.channel_id,
        v_detail.channel_title,
        v_detail.channel_url,
        channel.description,
        0
      ]
      @logger.info("Saving: #{v.title} - #{video_url(v.id)}")
      sleep 1
    end
  end
end

private

def today
  from = Time.now.utc.beginning_of_day.rfc3339
  now = Time.now.utc.rfc3339
  { from: from, to: now }
end

def this_month
  from = Time.now.utc.beginning_of_month.rfc3339
  now = Time.now.utc.rfc3339
  { from: from, to: now }
end

def last_month
  from = Time.now.utc.last_month.beginning_of_month.rfc3339
  to = Time.now.utc.last_month.end_of_month.rfc3339
  { from: from, to: to }
end

def specify_year_month
  year_month = /(?<year>\d.*)\-(?<month>\d.*)$/.match(ARGV.first)
  year = year_month['year'].to_i
  month = year_month['month'].to_i
  from = Time.new(year, month).beginning_of_month.utc.rfc3339
  to = Time.new(year, month).end_of_month.utc.rfc3339
  { from: from, to: to }
end

def video_url(id)
  "https://www.youtube.com/watch?v=#{id}"
end

# main
begin
  @logger = logger
  @logger.info('Start saving video list...')

  if ARGV.empty?
    save_japanese_cm_videos
  else
    case ARGV.first
    when 'last_month'
      save_japanese_cm_videos(last_month)
    when 'this_month'
      save_japanese_cm_videos(this_month)
    when /\d.*\-\d.*$/
      save_japanese_cm_videos(specify_year_month)
    end
  end
rescue StandardError => err
  @logger.fatal('Oops! There is something wrong!')
  @logger.fatal(err)
end
