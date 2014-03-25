require 'activerecord-sqlserver-adapter'
require 'mws-rb'
require_relative 'amazon_dump/version'
require_relative 'amazon_dump/api.rb'
require_relative 'amazon_dump/database.rb'
require_relative 'amazon_dump/dump_reader.rb'
require_relative 'amazon_dump/builder.rb'

module AmazonDump
  def self.new(options={})
		b = Builder.new
		b.send_data
  end
end

AmazonDump.new