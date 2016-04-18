class IssueDirective < DirectivesUser
    belongs_to :personal_directive, :foreign_key => :directive_id
    belongs_to :delegate, :foreign_key => :user_id
end