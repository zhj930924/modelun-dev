class UpdateCrisis < DirectivesUser
    belongs_to :crisis_update, :foreign_key => :directive_id
    belongs_to :crisis, :foreign_key => :user_id
end