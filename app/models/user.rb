class User < ActiveRecord::Base

  validates :password_digest, :username, :session_token, presence: true
  validates :password, length:  {minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @passwrd = password
  end

  def is_password?(password)
    pw_digest = BCrypt::Password.new(self.password_digest)
    pw_digest.is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def reset_session_token
    self.session_token = generate_session_token
    self.save!
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= generate_session_token
  end


  def generate_session_token
    SecureRandom.urlsafe_base64(16)
  end


end
