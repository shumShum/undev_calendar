class DashboardController < ApplicationController
	
	def index
		@events = [Event.new(date: Date.today, description: "bla bla bla"), Event.new(date: Date.today + 10.day, description: "bla bla bla 2")]
	end

end