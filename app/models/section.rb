class Section < ApplicationRecord
    validates :title, presence:true
    belongs_to :project, foreign_key: :project_id
    has_many :tasks, as: :taskable, dependent: :destroy
end
