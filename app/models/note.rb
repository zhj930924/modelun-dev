class Note < Directive
    has_many :note_takes, :foreign_key => :directive_id
    has_many :crises, through: :note_takes
end