class NoteTake < DirectivesUser
    belongs_to :note, :foreign_key => :directive_id
    belongs_to :crisis, :foreign_key => :user_id
end