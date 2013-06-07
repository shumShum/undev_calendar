# encoding: utf-8
class Event < ActiveRecord::Base
  attr_accessible :description, :date

  validates :description, presence: true
  validates :date, presence: true
end
