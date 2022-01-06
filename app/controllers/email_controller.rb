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
    MymailerMailer.simple_send("sgs1159@naver.com", "sgs1159@gmail.com", "제목입니다.", "내용입니다.").deliver_now
    MymailerMailer.simple_send("sgs1159@naver.com", "sgs1159@gmail.com", "제목입니다2.", "내용입니다2.").deliver_later
    redirect_to '/'
  end

  def send_emailer


    @email = 'sgs1159@naver.com'
    UserMailer.welcome_email.deliver_later
    redirect_to '/'

  end
end
