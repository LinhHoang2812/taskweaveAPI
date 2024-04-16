class Api::V1::ProjectsSerializer < ActiveModel::Serializer
  attributes :id,:title,:user_id,:sections
  #has_many :sections, serializer: Api::V1::SectionsSerializer
  
  def sections 
    sections=[]
    object.sections.each do |section|
      section_obj = section.as_json
      section_obj[:tasks]= section.tasks.sort_by { |task| task[:position]}
      sections.append(section_obj)
    end
    sections = sections.sort_by {|section| section["position"]}
    sections
  end
  
  
   
end
