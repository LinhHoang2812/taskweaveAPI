class Api::V1::TasksSerializer < ActiveModel::Serializer
  attributes :id,:title,:des,:due_date
end
