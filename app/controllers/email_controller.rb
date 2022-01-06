require "redis"
require 'mail'
require 'net/smtp'

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
    if (@authenticate_code == 0)
      @result = "인증시간이 초과되었습니다. 재인증을 해주세요."
    elsif (@authenticate_code != @param)
      @result = "잘못된 번호입니다. 인증번호 확인 후 정확히 입력해주세요."
    else
      @result = "인증되었습니다"
      redis.del(params[:email])
    end
  end

  def send_email

    message = <<MESSAGE_END
From: Private Person <me@fromdomain.com>
To: A Test User <sgs1159@naver.com>
MIME-Version: 1.0
Content-type: text/html
Subject: SMTP e-mail test

This is an e-mail message to be sent in HTML format

<b>This is HTML message.</b>
<h1>This is headline.</h1>
MESSAGE_END

    Net::SMTP.start('localhost') do |smtp|
      smtp.send_message message, 'me@fromdomain.com', 'sgs1159@naver.com'
    end
  end
end
