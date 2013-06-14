# encoding: utf-8
class Event < ActiveRecord::Base
  attr_accessible :description, :date, :time, :is_repeat, :repeat_days, :repeat_type

  validates :description, presence: true
  validates :date, presence: true
  validates :time, presence: true

  # before_save :check_repeat

  def add_repeat_day(day)
  	if repeat_days.present?
  		repeat_days_arr = repeat_days.split(',').push(day).uniq
  	else
  		repeat_days_arr = [day]
  	end
  	self.update_attribute(:repeat_days, repeat_days_arr.join(','))
  end

  def del_repeat_day(day)
    if repeat_days.present?
      repeat_days_arr = repeat_days.split(',').reject{|x| x == day}
      self.repeat_days = repeat_days_arr.join(',')
      save
    end
  end

  private

  def check_repeat
    self.repeat_days = "" unless is_repeat
  end
end
