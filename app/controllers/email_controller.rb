require "redis"

class EmailController < ApplicationController
  def index
    redis = Redis.new
    @email = redis.get("mykey")
  end

  def send

  end
end
