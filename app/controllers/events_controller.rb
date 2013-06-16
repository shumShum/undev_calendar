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
		repeat_events = []
		@events.select{|x| x.is_repeat}.each do |e|
			if e.repeat_days.present?
				repeat_days = e.repeat_days.split(' ')
				repeat_days.each do |d|
					if e.repeat_type == "week"
						d_w = (Date::ABBR_DAYNAMES.index(d) - Date.new(2013,6).wday)%7 + 1
						n_d = Date.new(2013,6,d_w)
						[n_d - 1.week, n_d, n_d + 1.week, n_d + 2.week, n_d + 3.week, n_d + 4.week].each do |dm|
							if dm > e.date.to_date 
								rep_event = Event.new(e.as_json.reject{|key| key == "updated_at" || key == "created_at"})
								rep_event[:id] = e.id
								rep_event[:date] = dm
								repeat_events.push rep_event 
							end
						end
					end
					if e.repeat_type == "month"
					end
				end
			end
		end
		@events = @events + repeat_events
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
		gon.rabl
	end

	def update
		@event = Event.find(params[:id])
		@event.repeat_type = params[:repeat_of] 
		@event.repeat_days = params[:repeat_days].join(" ") if params[:repeat_days].present? 
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
		render nothing: true
	end

	def del_repeat_day
		@event = Event.find(params[:event_id])
		@event.del_repeat_day(params[:day])
		render nothing: true
	end
end