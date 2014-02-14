require 'amazon_dump/version'
require 'activerecord'
require 'mws-rb'
require 'rails-sqlserver'
require_relative 'amazon_dump/api.rb'

module AmazonDump
  def self.new(options={})
    @connection = API.new(options)
  end
end
