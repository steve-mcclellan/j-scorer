class User < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_many :topics, dependent: :destroy

  attr_accessor :remember_token, :reset_token
  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token (22 characters long).
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 1.hour.ago
  end

  def all_game_summary
    stats = { round_one: { right: 0, wrong: 0, pass: 0,
                           dd_right: 0, dd_wrong: 0,
                           score: 0, possible_score: 0 },
              round_two: { right: 0, wrong: 0, pass: 0,
                           dd_right: 0, dd_wrong: 0,
                           score: 0, possible_score: 0 },
              finals: { right: 0, wrong: 0 } }
    games.each { |game| update_stats(stats, game.all_category_summary) }
    stats
  end

  def total_score
    stats = all_game_summary
    stats[:round_one][:score] + stats[:round_two][:score]
  end

  def average_score
    games_played = games.count
    return nil if games_played.zero?
    total_score / games_played.to_f
  end

  def efficiency
    stats = all_game_summary
    possible_score = stats[:round_one][:possible_score] +
                     stats[:round_two][:possible_score]
    return nil if possible_score.zero?
    total_score / possible_score.to_f
  end

  private

  def update_stats(stats, game_summary)
    [:round_one, :round_two].each do |round|
      [:right, :wrong, :pass].each do |stat|
        stats[round][stat] += game_summary[round][stat]
      end

      add_dd_stats(stats, game_summary, round)
      stats[round][:score] += game_summary[round][:score]
      stats[round][:possible_score] += game_summary[round][:possible_score]
    end

    add_final_stats(stats, game_summary)
  end

  def add_dd_stats(stats, game_summary, round)
    game_summary[round][:dd].each do |_row, result|
      case result
      when :correct then stats[round][:dd_right] += 1
      when :incorrect then stats[round][:dd_wrong] += 1
      end
    end
  end

  def add_final_stats(stats, game_summary)
    stats[:finals][:wrong] += 1 if game_summary[:final_status] == 1
    stats[:finals][:right] += 1 if game_summary[:final_status] == 3
  end
end
