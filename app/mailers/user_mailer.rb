class UserMailer < ApplicationMailer
  default from: "noreply@example.com"

  def account_activation(user)
    @user = user
    mail to: user.email_address, subject: "【Tutorial App】アカウントの有効化"
  end
end
