#!/usr/bin/env ruby
require "yt"
require "csv"
require "socket"
require_relative "helper_logger"

["YT_API_KEY", "YT_CLIENT_ID", "YT_CLIENT_SECRET"].each do |yt_env_var|
  raise "Missing #{yt_env_var} environment variable!" if ENV["#{yt_env_var}"].nil?
end

def read_videos_csv(path)
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
  access_token = /code=(?<access_token>.*)\sHTTP/.match(@request)[:access_token]
  account = Yt::Account.new authorization_code: access_token, redirect_uri: redirect_uri
  puts account.email

  server.close
rescue => err
  @logger.fatal("Oops! There is something wrong!")
  @logger.fatal(err)
end
