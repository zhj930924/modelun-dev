class Directive < ActiveRecord::Base
    # before_action :logged_in_user, only: [:create, :destroy]
    # before_action :correct_user, only: :destroy
    default_scope -> { order(created_at: :desc) }
    mount_uploader :picture, PictureUploader
    has_and_belongs_to_many :users
    has_many :comments
    self.inheritance_column = :type
    
    validates :title, presence: true, length: { maximum: 100}
    validates :content, presence: true
    validates :type, presence: true

    has_many :directives_tags
    has_many :tags, through: :directives_tags
    
    def self.types
        %w(PersonalDirective Resolution CrisisUpdate Note)
    end
    
    #Identification of Filterrific for Directive class    
    filterrific(
        available_filters: [
            :search_query,
            :with_tag_name,
            :with_user,
            :with_directive_type,
            :with_comments,
            :with_directive_status
        ]
    )
    
    #Scope definitions
        
    scope :search_query, lambda { |query|
      # Searches the students table on the 'first_name' and 'last_name' columns.
      # Matches using LIKE, automatically appends '%' to each term.
      # LIKE is case INsensitive with MySQL, however it is case
      # sensitive with PostGreSQL. To make it work in both worlds,
      # we downcase everything.
      return nil  if query.blank?
    
      # condition query, parse into individual keywords
      terms = query.downcase.split(/\s+/)
    
      # replace "*" with "%" for wildcard searches,
      # append '%', remove duplicate '%'s
      terms = terms.map { |e|
        (e.gsub('*', '%') + '%').gsub(/%+/, '%')
      }
      # configure number of OR conditions for provision
      # of interpolation arguments. Adjust this if you
      # change the number of OR conditions.
      num_or_conds = 2
      where(
        terms.map { |term|
          "(LOWER(directives.content) LIKE ? OR LOWER(directives.title) LIKE ?)"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conds }.flatten
      )
    }
    

    scope :with_tag_name, lambda { |tag_id|
      return nil if tag_id == [""]
      where(tags: {id: tag_id}).joins(:tags)
    }
    
    scope :with_user, lambda { |user_id|
      return nil if user_id == [""]
      where(users: {id: user_id}).joins(:users)
    }
    
    scope :with_directive_type, lambda { |type|
      return nil if type == [""]
      where(directives: {type: type})

    }

    scope :with_comments, lambda {
      where(
          'EXISTS (SELECT 1 from comments WHERE directives.id = comments.directive_id)'
      )
    }

    scope :with_directive_status, lambda { |status|
      return nil if status == [""]
      where(directives: {status: status})
    }

    scope :with_committees, lambda {|committee|
      return nil if committee == [""]
      where(users: {committee: committee}).joins(:users)
    }

    scope :with_public, lambda { |public|
      return nil if public == [""]
      where(directives: {public: public})
    }
    

end
