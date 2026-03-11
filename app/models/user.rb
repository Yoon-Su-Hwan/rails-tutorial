class User < ApplicationRecord
  attr_accessor :activation_token, :security_answer

  SECURITY_QUESTIONS = [
    "母親の旧姓は何ですか？",
    "ペットの名前は何ですか？",
    "出身地はどこですか？",
    "最初に好きになったアーティストは誰ですか？",
    "小学校の名前は何ですか？"
  ].freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  # Active Relationships (내가 팔로우하는 관계)
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  # Passive Relationships (나를 팔로우하는 관계)
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  # 팔로잉/팔로워 유저 목록을 직접 가져오기
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :birthdate, presence: true
  validates :phone_number, presence: true
  validates :address, presence: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  # 보안 질문 유효성 검사 (신규 가입 시에만 적용)
  validates :security_question_id, presence: true, inclusion: { in: 0...SECURITY_QUESTIONS.length }, on: :create
  validates :security_answer, presence: true, on: :create

  before_validation :create_activation_digest, on: :create
  before_save :encrypt_security_answer

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
    UserMailer.account_activation(self, self.activation_token).deliver_now
  end

  # 보안 질문의 답이 맞는지 확인합니다.
  def correct_security_answer?(answer)
    return false if security_answer_digest.nil?
    BCrypt::Password.new(security_answer_digest).is_password?(answer.to_s.strip.downcase)
  end

  # --- 팔로우 관련 편의 메서드 ---

  # 사용자를 팔로우합니다.
  def follow(other_user)
    following << other_user unless self == other_user
  end

  # 사용자를 언팔로우합니다.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 현재 사용자가 상대방을 팔로우하고 있는지 확인합니다.
  def following?(other_user)
    following.include?(other_user)
  end

  private

  # 활성화 토큰과 다이제스트를 생성합니다.
  def create_activation_digest
    self.activation_token ||= SecureRandom.urlsafe_base64
    self.activation_digest = BCrypt::Password.create(activation_token)
  end

  private

  # 보안 질문의 답을 암호화하여 저장합니다.
  def encrypt_security_answer
    if security_answer.present?
      self.security_answer_digest = BCrypt::Password.create(security_answer.to_s.strip.downcase)
    end
  end
end
