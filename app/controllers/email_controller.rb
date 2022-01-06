require "redis"
require 'mail'
class EmailController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  def index
    redis = Redis.new
    @email = redis.get("mykey")
  end

  def authenticate_send_email
    redis = Redis.new()
    @authenticate_code = rand(100000..999999)
    redis.set(params[:email], @authenticate_code)
    redis.expire(params[:email], 300)
  end

  def authenticate_check
    redis = Redis.new
    @authenticate_code = redis.get(params[:email]).to_i
    @param = params[:code].to_i
    if(@authenticate_code == 0)
      @result = "인증시간이 초과되었습니다. 재인증을 해주세요."
    elsif(@authenticate_code != @param)
      @result = "입력하신 번호가 다릅니다."
    else
      @result = "인증되었습니다"
      redis.del(params[:email])
    end
  end


  def send_email
    mail = Mail.new do
      from    'mikel@test.lindsaar.net'
      to      'sgs1159@naver.com'
      subject 'This is a test email'
      body    File.read('body.txt')
    end

    mail.to_s #=> "From: mikel@test.lindsaar.net\r\nTo: you@...
  end
end
