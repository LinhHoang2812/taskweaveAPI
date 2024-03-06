class User < ApplicationRecord
    has_secure_password validations: false

    validates :email, presence:true
    has_many :project, dependent: :destroy 
    has_many :tasks, dependent: :destroy
    
end
