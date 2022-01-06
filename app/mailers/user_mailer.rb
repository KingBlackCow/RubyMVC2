class UserMailer < ApplicationMailer
  default from: 'sgs1159@gmail.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: '회원가입을 축하합니다.')
  end
end