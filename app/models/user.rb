class User < ApplicationRecord
  attr_accessor :activation_token
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  before_create :create_activation_digest

  # 토큰이 다이제스트와 일치하는지 확인합니다.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # 계정을 활성화합니다.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 활성화 이메일을 발송합니다.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # 활성화 토큰과 다이제스트를 생성합니다.
  def create_activation_digest
    self.activation_token  = SecureRandom.urlsafe_base64
    self.activation_digest = BCrypt::Password.create(activation_token)
  end
end
