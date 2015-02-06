#!/usr/bin/env ruby
#
# Released under the same terms as Sensu (the MIT license); see LICENSE
# for details
#
# this handler writes event data to redis that has status 0

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'redis'

class StatusZero < Sensu::Handler
  def handle
    return unless @event['check']['status'] == 0

    begin
      host = settings['status_zero']['server']
      port = settings['status_zero']['port']
    rescue => e
      puts "failed to configure revent handler: #{e}"
    end

    begin
      redis = Redis.new(:host => host, :port => port)
      redis.hset("events:" + @event['client']['name'], @event['check']['name'], @event)
    rescue => e
      puts "failed to write event to redis: #{e}"
    end
  end
end

