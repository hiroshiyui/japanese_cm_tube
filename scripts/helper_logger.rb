#!/usr/bin/env ruby
require "logger"

private

def logger
  # Setup logger
  begin
    file = File.open("japanese_cm_tube.log", File::WRONLY | File::APPEND)
  rescue Errno::ENOENT
    file = File.open("japanese_cm_tube.log", File::WRONLY | File::APPEND | File::CREAT)
  end
  logger = Logger.new(file)
end
