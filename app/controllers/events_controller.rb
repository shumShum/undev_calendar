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
		# нужный календарь отображается в зависимости от параметра time_option;
		# здесь мы формируем дату, на которую будем ориентироваться при генерации повторения для событий
		# и вообще при отрисовке календаря
		time_option = params[:time_option].present? ? params[:time_option] : 'month'
		params[:year].present? ? @year = params[:year].to_i : @year = Date.today.year
		unless time_option == 'week'
			params[:month].present? ? @month = params[:month].to_i : @month = Date.today.month
			params[:day].present? ? @day = params[:day].to_i : @day = Date.today.day
			@week = @month * 4
		else
			@week = params[:month].to_i if params[:month].present?
			pre_date = Date.new(@year) + (@week.to_i-1).week
			wday = pre_date.wday == 0 ? 7 : pre_date.wday
			@begin_of_week = pre_date - (wday - 1).day
			@week.present? ? @month = @begin_of_week.month : @month = Date.today.month
			@day = @begin_of_week.day
		end
		@begin_month_date = Date.new(@year, @month)
		@date = Date.new(@year, @month, @day)

			# в зависимости от типа календаря тянем только события на данный промежуток времени
			# и всегда повторяющиеся события
			events = Event.arel_table
			if time_option == 'month'
				@events = Event.where(events[:is_repeat].eq(true).or(events[:date].in(@begin_month_date-1.week..@begin_month_date+1.month+1.week))).all
				actual_events = @events.select{|x| (x.date >= @begin_month_date-1.week) && (x.date <= @begin_month_date+1.month+1.week)}
			end

			if time_option == 'day'
				@events = Event.where(events[:is_repeat].eq(true).or(events[:date].eq(@date))).all
				actual_events = @events.select{|x| x.date.to_date == @date}
			end

			if time_option == 'week'
				@events = Event.where(events[:is_repeat].eq(true).or(events[:date].in(@date..@date + 1.week))).all
				actual_events = @events.select{|x| (x.date >= @date) && (x.date <= @date + 1.week)}
			end

				# генерируем повторения (ориентируемся на тип повторения и тип календаря)
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
										repeat_events.push new_repeat_event(e, dm)
									end
								end
								if (time_option == 'day')
									repeat_events.push new_repeat_event(e, @date) if Date::ABBR_DAYNAMES.index(d) == @date.wday
								end
								if (time_option == 'week')
									add_days = Date::ABBR_DAYNAMES.index(d)
									add_days = add_days == 0 ? 6 : add_days - 1
									repeat_events.push new_repeat_event(e, @date + add_days)
								end
							end
							if e.repeat_type == "month"
								if time_option == 'month' 
									begin
										n_d = Date.new(@year,@month,d.to_i)
									rescue
										n_d = Date.new(@year,@month+1,d.to_i)
									end
									[n_d, n_d + 1.month].each do |dm|
										repeat_events.push new_repeat_event(e, dm)
									end
								end
								if time_option == 'day'
									repeat_events.push new_repeat_event(e, @date) if (@day == d.to_i)
								end
								if (time_option == 'week')
									days = (@date..@date + 1.week).to_a.map{|x| x.day}
									if days.index(d.to_i).present?
										dm = days.index(d.to_i)
										repeat_events.push new_repeat_event(e, @date + dm.day)
									end
								end
							end
						end
					end
				end
				@events = actual_events + repeat_events.compact	

		@month_names = MONTH_NAMES
		@days_of_week_names = DAYS_OF_WEEK_NAMES	
		gon.time_option = time_option
	end

	def show
		@event = Event.find(params[:id])
	end
	
	# сюда передаем параметр time_option для редиректа на нужный календарь в экшене create
	def new
		@time_option = params[:time_option]
		@time = params[:time].present? ? params[:time] : Time.zone.parse("00:00:00")
		@event = Event.new(date: params[:date], time: @time)
	end

	def create
		@event = Event.new(params[:event])
	  if @event.save
	  	to = params[:time_option]
	  	year = @event.date.year
	  	month = @event.date.month
	  	day = @event.date.day
	  	if to =~ /week \d{2}/
	  		week = to.scan(/\d{2}/)[0]	
	  		url = "/events/week/#{year}/#{week}" 
	  	end
	  	url = "/events/day/#{year}/#{sprintf '%02d', month}/#{sprintf '%02d', day}" if to == 'day'
	  	url = "/events/month/#{year}/#{sprintf '%02d', month}" if to == 'month' || !to.present?
	    redirect_to url
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
			redirect_to "/events/month/#{@event.date.year}/#{sprintf '%02d', @event.date.month}"
		else
			render 'edit'
		end
	end

	def destroy
		redirect_to root_url if Event.find(params[:id]).destroy
	end

	private
		# метод, копирующий повторяющееся событие для отрисовки его на календаре
		def new_repeat_event(original, date)
			if date > original.date.to_date
				rep_event = Event.new(original.as_json.reject{|key| key == "updated_at" || key == "created_at"})
				rep_event[:id] = original.id
				rep_event[:date] = date
				rep_event
			else
				nil
			end
		end

end