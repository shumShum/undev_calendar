class EventsController < ApplicationController

	def index
		@events = Event.all
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
		@event.time = @event.time.strftime("%H-%M")
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

end