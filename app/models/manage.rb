class Manage < ActiveRecord::Base
    belongs_to :delegate
    belongs_to :crisis
end
