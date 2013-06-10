# encoding: utf-8
class Event < ActiveRecord::Base
  attr_accessible :description, :date, :time

  validates :description, presence: true
  validates :date, presence: true
  validates :time, presence: true
end
