class Agenda < ApplicationRecord
  belongs_to :team
  belongs_to :user
  has_many :articles, dependent: :destroy
  validates :title , presence: true, length:{maximum: 10}
end
