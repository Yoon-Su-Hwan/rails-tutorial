class UserMailer < ApplicationMailer
  default from: "s-yoon@ankh-systems.co.jp"

  def account_activation(user, token)
    @user = user
    @token = token
    mail to: user.email_address, subject: "【Tutorial App】アカウントの有効化"
  end
end
