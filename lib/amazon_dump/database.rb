require 'yaml'
require 'activerecord-sqlserver-adapter'
class Database
	
	def initialize
		@config = YAML::load(File.open('config.yml'))
	end

	def connect
		connection = ActiveRecord::Base.establish_connection(@config[:server])
	end

	def config
		@config
	end

end