class Api::V1::SectionsSerializer < ActiveModel::Serializer
  attributes :id,:title,:tasks

  def tasks
    object.tasks = object.tasks.sort_by { |task| task[:position]}

  end 

end
