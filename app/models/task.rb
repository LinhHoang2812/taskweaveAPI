class Task < ApplicationRecord
    attr_accessor :validate_due_date
    belongs_to :taskable, polymorphic: true, optional: true
    belongs_to :user
    validates :due_date, presence: true, if: :validate_due_date?

    def validate_due_date?
        validate_due_date  == true
    end
end
