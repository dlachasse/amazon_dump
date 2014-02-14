require_relative './config.yml'

class API
	
	def initialize(options={})
		config = YAML::load(File.open('config.yml'))
		@mws = MWS.new(
		  host: config["amazon"]["host"],
		  aws_access_key_id: config["amazon"]["aws_access_key_id"],
		  aws_secret_access_key: config["amazon"]["aws_secret_access_key"],
		  seller_id: config["amazon"]["seller_id"]
		)
	end

end