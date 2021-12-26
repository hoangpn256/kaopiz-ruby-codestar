class User < ApplicationRecord
  acts_as_voter 
  has_one :profile, dependent:   :destroy
  has_many :articles
  has_and_belongs_to_many :roles
  #  following of user
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent:   :destroy
  has_many :followings, through: :active_follows, source: :followed
  #  user's follower
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent:   :destroy
  has_many :followers, through: :passive_follows, source: :follower

  validates :username, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: true }

  after_create :set_defaul_role
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :lockable, :omniauthable, authentication_keys: [:login], omniauth_providers: [:google_oauth2] 

        #  def self.from_google(email:, full_name:, uid:, avatar_url:)
          # return nil unless email =~ /@gmail.com\z/
          # create_with(uid: uid, full_name: full_name, avatar_url: avatar_url, password: Devise.friendly_token[0,20]).find_or_create_by!(email: email)
        def self.from_omniauth(auth)
          user = User.find_by(email: auth.info.email)
          if user and user.confirmed?
            user.provider = auth.provider
            user.uid = auth.uid
            return user
          end
        
          where(auth.slice(:provider, :uid)).first_or_create do |user|
            user.skip_confirmation! 
            user.provider = auth.provider
            user.uid = auth.uid
            user.email = auth.info.email
            user.password = Devise.friendly_token[0,20]
            user.full_name = auth.info.name
          end
        end
        
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      # where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  def get_user_info
    self.username? ? self.username : self.email
  end

  def set_defaul_role
    self.roles << Role.find_by(role: 'normal_user')
  end
  def add_defaul_profile
    @profile = self.build_profile()
    @profile.save
  end

end
