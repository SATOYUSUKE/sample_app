class User < ApplicationRecord
#before_saveコールバックにブロックを渡してユーザーのメールアドレスを設定します。設定されるメールアドレスは、現在の値をStringクラスのdowncaseメソッドを使って小文字バージョンにしたものです
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  #maximumを使ってユーザー名の最大文字数を制限していましたが、これと似たような形式のminimumというオプションを使って、最小文字数のバリデーションを実装することができます。
  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
