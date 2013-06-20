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

	MONTH_NAMES = [
		'Январь',
		'Февраль',
		'Март',
		'Апрель',
		'Май',
		'Июнь',
		'Июль',
		'Август',
		'Сентябрь',
		'Октябрь',
		'Ноябрь',
		'Декабрь'
	]

	def index
		params[:year].present? ? @year = params[:year].to_i : @year = Date.today.year
		params[:month].present? ? @month = params[:month].to_i : @month = Date.today.month
		params[:day].present? ? @day = params[:day].to_i : @day = Date.today.day
		@begin_month_date = Date.new(@year, @month)
		@date = Date.new(@year, @month, @day)
		time_option = params[:time_option].present? ? params[:time_option] : 'month'

			if time_option == 'month'
				events = Event.arel_table
				@events = Event.where(events[:is_repeat].eq(true).or(events[:date].in(@begin_month_date-1.week..@begin_month_date+1.month+1.week))).all
				actual_events = @events.select{|x| (x.date >= @begin_month_date-1.week) && (x.date <= @begin_month_date+1.month+1.week)}
			end

			if time_option == 'day'
				events = Event.arel_table
				@events = Event.where(events[:is_repeat].eq(true).or(events[:date].eq(@date))).all
				actual_events = @events.select{|x| x.date.to_date == @date}
			end

				
				repeat_events = []
				@events.select{|x| x.is_repeat}.each do |e|
					if e.repeat_days.present?
						repeat_days = e.repeat_days.split(' ')
						repeat_days.each do |d|
							if e.repeat_type == "week"
								if time_option == 'month'
									d_w = (Date::ABBR_DAYNAMES.index(d) - @begin_month_date.wday)%7 + 1
									n_d = Date.new(@year,@month,d_w)
									[n_d - 1.week, n_d, n_d + 1.week, n_d + 2.week, n_d + 3.week, n_d + 4.week, n_d + 5.week].each do |dm|
										if dm > e.date.to_date 
											rep_event = Event.new(e.as_json.reject{|key| key == "updated_at" || key == "created_at"})
											rep_event[:id] = e.id
											rep_event[:date] = dm
											repeat_events.push rep_event 
										end
									end
								end
								if (time_option == 'day') && (@date > e.date.to_date)
									if Date::ABBR_DAYNAMES.index(d) == @date.wday
										rep_event = Event.new(e.as_json.reject{|key| key == "updated_at" || key == "created_at"})
										rep_event[:id] = e.id
										rep_event[:date] = @date
										repeat_events.push rep_event
									end
								end
							end
							if e.repeat_type == "month"
								if time_option == 'month' 
									n_d = Date.new(@year,@month,d.to_i)
									[n_d, n_d + 1.month].each do |dm|
										if n_d > e.date.to_date
											rep_event = Event.new(e.as_json.reject{|key| key == "updated_at" || key == "created_at"})
											rep_event[:id] = e.id
										  rep_event[:date] = dm
											repeat_events.push rep_event
										end
									end
								end
								if time_option == 'day'
									if (@day == d.to_i) && (@date > e.date.to_date)
										rep_event = Event.new(e.as_json.reject{|key| key == "updated_at" || key == "created_at"})
										rep_event[:id] = e.id
										rep_event[:date] = @date
										repeat_events.push rep_event
									end
								end
							end
						end
					end
				end
				@events = actual_events + repeat_events	

		@month_names = MONTH_NAMES
		@days_of_week_names = DAYS_OF_WEEK_NAMES	
		gon.time_option = time_option
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
	    redirect_to "/events/month/#{@event.date.year}/#{sprintf '%02d', @event.date.month}"
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
		@event.repeat_days = params[:new_number] if params[:new_number].present? 
		if @event.update_attributes(params[:event])
			redirect_to root_url
		else
			render 'edit'
		end
	end

	def destroy
		redirect_to root_url if Event.find(params[:id]).destroy
	end

	def back_month
		@month = params[:month].to_i - 1
		render 'index'
	end

	def forward_month
	end 

end