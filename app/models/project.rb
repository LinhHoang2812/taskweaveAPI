class Project < ApplicationRecord
    validates :title, presence:true
    has_many :sections, dependent: :destroy
    belongs_to :user, foreign_key: :user_id
    has_many :tasks, as: :taskable, dependent: :destroy




end
