#! /user/bin/env ruby
# coding: utf-8

require 'httpclient'
require 'nokogiri'
require 'json'

class Contributer
  
  attr_accessor :github_user_name, :slack_web_hook_url, :channel, :post_user_name, :post_icon_emoji, :force
  
  def initialize(options = {})
    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    yield(self) if block_given?

    @post_user_name = 'GitHubContributer' unless @post_user_name
    @post_icon_emoji = ':warning:' unless @icon_emoji
    @post_text = 'WARNING!! Nothing contributing today!!'
  end

  def exec(time)
    client = HTTPClient.new
    time = Time.now

    body = client.get("https://github.com/users/#{@github_user_name}/contributions").body

    doc = Nokogiri.parse(body)

    rects = doc.css('rect')

    target = rects.find{|x| x.attr('data-date') == time.to_date.to_s}

    if target.attr('data-count').to_i <= 0 || @force
      payload = {
        username: @post_user_name,
        icon_emoji: @post_icon_emoji,
        text: @post_text,
      }

      post_data = {
        payload: payload.to_json
      }

      res = client.post(@slack_web_hook_url, post_data)

      if res.status != 200
        raise RuntimeError.new("Error: invalid status. #{res.status} - #{res.body}")
      end
    end
  end
  
end
