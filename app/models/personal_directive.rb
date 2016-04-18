class PersonalDirective < Directive
    has_many :issue_directives, :foreign_key => :directive_id
    has_many :delegates, through: :issue_directives
    
end