class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :timeoutable
    
    has_and_belongs_to_many :directives
    attr_accessor :remember_token
    #before_save {self.email = email.downcase}
    #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    #self.inheritance_column = :type
    validates :committee, presence: true
    validates :position, presence: true
    #validates :email, presence: true, length: { maximum: 255},
    #  format: {with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
    validates :name, presence: true, length: {maximum: 50}
    #validates :password, presence: true, length: { minimum: 6}, allow_nil: true
    validates :type, presence: true
    
    acts_as_messageable
    
    
    
    def mailboxer_name
        self.name
    end

    def mailboxer_email(object)
        self.email
    end
    
    def self.types
        %w(Delegate Crisis)
    end
    
      #Return hash digest of a given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    def sign(d)
        resolution_signings.create(directive_id: d.id)
    end
    
    def unsign(d)
        resolution_signings.find_by(directive_id: d.id).destroy
    end
    
    def signed?(d)
        resolution_signings.include?(directive_id)
    end
    
    def sponsor(d)
        resolution_sponsorships.create(directive_id: d.id)
    end
    
    def unsign(d)
        resolution_sponsorships.find_by(directive_id: d.id).destroy
    end

    def sponsored?(d)
        resolution_sponsorships.include?(directive_id)
    end
    
    def self.options_for_select
      order('LOWER(position)').map { |e| [e.position, e.id] }
    end
    
# define ActiveRecord scopes for
# :search_query, :sorted_by, :with_country_id, and :with_created_at_gte
    
end
