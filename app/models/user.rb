class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name,  presence: true, length: { maximum: 50 }
  # :emailの有効条件の定数を定義
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    # 定義した条件で有効性を検証
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :department, length: {in: 2..30}, allow_blank: true
  # :passwordのハッシュ化と:password_confirmation使用可、authenticateメソッド使用可
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  
  # 渡された文字列のハッシュ値を返します。
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返します。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためハッシュ化したトークンをデータベースに記憶します。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致すればtrueを返します。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了します。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄します。
  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = find_by(email: row["email"]) || new
      user.attributes = row.to_hash.slice(*updatable_attributes)
      user.save!(validate: false)
    end
  end
  
  def self.updatable_attributes
    [
      'name',
      'email',
      'department',
      'employee_number',
      'uid',
      'basic_work_time',
      'designated_work_start_time',
      'designated_work_end_time',
      'superiors',
      'admin',
      'password'
    ]
  end
  
end