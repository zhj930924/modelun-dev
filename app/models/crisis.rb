class Crisis < User
    has_many :update_crises, :foreign_key => :user_id
    has_many :crisis_updates, through: :update_crises
    
    has_many :note_takes, :foreign_key => :user_id
    has_many :notes, through: :note_takes
    
    has_many :manages, foreign_key: "crisis_id"
    has_many :delegates, through: :manages 
end