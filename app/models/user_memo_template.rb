class UserMemoTemplate < ApplicationRecord
  belongs_to :user
  belongs_to :project

  after_create :generate_number

  def generate_number
    number = UserMemoTemplate.last(2).first.try(:number)
    if number
      number = number + 1
    else
      number = 0001
    end
    update(number: number)
  end 
end
