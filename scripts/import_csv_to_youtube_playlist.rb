#!/usr/bin/env ruby
require "yt"
require "csv"
require "socket"
require "uri"
require_relative "helper_logger"

["YT_API_KEY", "YT_CLIENT_ID", "YT_CLIENT_SECRET"].each do |yt_env_var|
  raise "Missing #{yt_env_var} environment variable!" if ENV["#{yt_env_var}"].nil?
end

private

def select_csv
  csv_files = Dir.glob("*.csv")
  csv_files.each_with_index do |csv, index|
    puts "  #{index}. #{csv}"
  end
  puts "Select a CSV file for importing: "
  choice = gets.chomp.to_i

  CSV.read(csv_files[choice], :force_quotes => true, :headers => true)
end

# main
begin
  @logger = logger
  @logger.info("Start importing playlist...")

  # OAuth flow
  redirect_uri = "http://127.0.0.1:5566/"
  auth_url = Yt::Account.new(scopes: ["youtube", "youtube.readonly", "userinfo.email"], redirect_uri: redirect_uri).authentication_url
  puts "Visit this URL: #{auth_url}"

  # fetch access token
  server = TCPServer.new 5566
  while session = server.accept
    @request = session.gets

    session.print "HTTP/1.1 200\r\n"
    session.print "Content-Type: text/html\r\n"
    session.print "\r\n" # 3
    session.print "Got access token, you can safely close this browser tab now."
    session.close
    break
  end
  access_token = URI.unescape(/code=(?<access_token>.*)\sHTTP/.match(@request)[:access_token])

  # create or open playlist
  account = Yt::Account.new authorization_code: access_token, redirect_uri: redirect_uri
  puts "Enter title of playlist: "
  title = gets.chomp
  playlist = account.playlists.find { |pl| pl.title == title }
  if playlist.nil?
    playlist = account.create_playlist(title: title)
  end

  # import to playlist
  select_csv.each do |v|
    if playlist.playlist_items.find { |item| item.video_id == v["id"] }
      @logger.info "Skip adding the existed video: '#{v["id"]}'"
      next
    else
      @logger.info "Adding '#{v["id"]}' to playlist..."
      playlist.add_video(v["id"]) if v["be_excluded"].to_i.zero?
      sleep 1
    end
  end

  server.close
rescue => err
  @logger.fatal("Oops! There is something wrong!")
  @logger.fatal(err)
end
