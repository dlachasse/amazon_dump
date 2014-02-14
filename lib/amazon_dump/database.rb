require_relative './config.yml'

class Database
	
	def initialize
		config = YAML::load(File.open('config.yml'))
		@connection = ActiveRecord::Base.establish_connection(config[:server])
	end

end