class Api::V1::ProjectsSerializer < ActiveModel::Serializer
  attributes :id,:title,:user_id
  has_many :sections, serializer: Api::V1::SectionsSerializer
  

  
  
   
end
