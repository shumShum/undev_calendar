# encoding: utf-8
class EventsController < ApplicationController

	DAYS_OF_WEEK_NAMES = [
		['Пн', 'Mon'], 
		['Вт', 'Tue'], 
		['Ср', 'Wed'], 
		['Чт','Thu'], 
		['Пт','Fri'], 
		['Сб','Sat'], 
		['Вс','Sun']]

	def index
		@events = Event.all
		# Event.new(e.as_json.reject{|key| key == "updated_at" || key == "created_at"})
	end

	def show
		@event = Event.find(params[:id])
	end
	
	def new
		@event = Event.new(date: params[:date])
	end

	def create
		@event = Event.new(params[:event])
	  if @event.save
	    redirect_to root_url
	  else
	    render 'new'
	  end
	end

	def edit
		@event = Event.find(params[:id])
		@event.date = @event.date.strftime("%Y-%m-%d")
		@event.time = @event.time.strftime("%H:%M")
		@days_of_week_names = DAYS_OF_WEEK_NAMES
	end

	def update
		@event = Event.find(params[:id])
		if @event.update_attributes(params[:event])
			redirect_to root_url
		else
			render 'edit'
		end
	end

	def destroy
		redirect_to root_url if Event.find(params[:id]).destroy
	end

	def new_repeat_day
		@event = Event.find(params[:event_id])
		@event.add_repeat_day(params[:day])
		redirect_to edit_event_path(@event)
	end

end