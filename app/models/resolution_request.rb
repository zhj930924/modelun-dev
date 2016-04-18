class ResolutionRequest < DirectivesUser
  belongs_to :resolution, :foreign_key => :directive_id
  belongs_to :delegate, :foreign_key => :user_id
end