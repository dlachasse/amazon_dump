require 'yaml'
require 'mws-rb'
class API
	
	def initialize(options={})
		@config = YAML::load(File.open('./config.yml'))
	end

	def connect
		@mws = MWS.new(
		  host: @config["amazon"]["host"],
		  aws_access_key_id: @config["amazon"]["aws_access_key_id"],
		  aws_secret_access_key: @config["amazon"]["aws_secret_access_key"],
		  seller_id: @config["amazon"]["seller_id"],
		  marketplace_id: @config["amazon"]["marketplace_id"]
		)
	end

	def config
		@config
	end

	def prebuild_params
		params = {"MarketplaceId" => read_config("amazon")["marketplace_id"], "IdType" => "UPC"}
	end

	def read_config(set)
		@config[set]
	end

end