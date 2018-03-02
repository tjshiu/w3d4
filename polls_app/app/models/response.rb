# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  answer_choice_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Response < ApplicationRecord
  validates :user_id, presence: true
  validates :answer_choice_id, presence: true

  validate :respondent_already_answered?

  belongs_to :answer_choice,
    primary_key: :id,
    foreign_key: :answer_choice_id,
    class_name: :AnswerChoice

  belongs_to :respondent,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_one :question,
    through: :answer_choice,
    source: :question

  def sibling_responses
    current_id = self.id
    self.question.responses.where.not(id: current_id)
  end

  def respondent_already_answered?
    if self.sibling_responses.exists?(user_id: self.user_id)
      errors[:user_id] << 'no. You were here already.'
    end
  end

end
