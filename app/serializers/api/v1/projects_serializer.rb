class Api::V1::ProjectsSerializer < ActiveModel::Serializer
  attributes :id,:title,:user_id
  has_many :sections
  has_many :tasks
  
   
end
