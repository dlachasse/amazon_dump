require 'yaml'
require 'csv'
require_relative './dump_reader.rb'
require_relative './api.rb'
# require_relative './database.rb'

module Request

	class Builder
		def initialize
			@dump = DumpReader.new
			@api = API.new
			# @db = Database.new
		end

		def build_connection
			@mws = @api.connect
			# db = @db.connect
		end

		def read_config(set)
			@config = YAML::load(File.open('config.yml'))
			@config[set]
		end

		def send_data
			build_connection unless defined? @mws
			until @dump.current_end_row == @dump.last_row do
				@dump.increment
				params = set_params
			 	send_to_parser @mws.products.get_matching_product_for_id(eval(params))
			end
		end

		def set_params
			params = @api.prebuild_params
			@upcs = @dump.build_hash.map { |upc| upc.values }
			@dump.build_hash.map { |o| params.merge!(o) }
			Tools.to_string_representation_of_hash params
		end

		def send_to_parser response
			parse = Parser.new(response, @upcs)
			parse.build_objects
			final_output = parse.output_results
			Tools.write_to_file(final_output)
		end

	end

	class Parser

		def initialize(response, upcs)
			@doc = Nokogiri::XML(response.parsed_response)
	    @upcs = upcs
	    @attrs = set_attrs
	    @products = []
	    @output_object = []
	    @ns = "http://mws.amazonservices.com/schema/Products/2011-10-01"
	    @ns2 = "http://mws.amazonservices.com/schema/Products/2011-10-01/default.xsd"
	    set_methods
		end

	  def set_methods
	    @attrs.each do |m|
	      (class << self; self; end).class_eval do
	        define_method("get_#{m}") do |noko_object, type, instance|
	          object = noko_object.xpath("//ns2:#{type}", { "ns2" => @ns2 })
	          if object.count > 1
			        object[instance].text
			      else
			        object.text
			      end
	        end
	      end
	    end
	  end

	  def select_object noko_object, type
	    if noko_object.xpath("//ns2:#{type}", { "ns2" => @ns2 }).text[0].is_a? String
	      noko_object.xpath("//ns2:#{type}", { "ns2" => @ns2 })
	    else
	      noko_object.xpath("//ns:#{type}", { "ns" => @ns })
	    end
	  end

	  def build_objects
	    @doc.css('Product').map {|a| @products << a }
	    @products.each_with_index do |product, i|
	      url = get_URL(product, "URL", i).gsub(/SL75/, "SL1500")
	      p url
	      @output_object << url
	    end
	    @output_object
	  end

	  def set_attrs
	  	%w(ASIN Brand Color Department Feature1 Feature2 Feature3 Feature4 Feature5 ItemDimensions Weight Label Amount CurrencyCode Manufacturer Model NumberOfItems PackageDimensions Height Length Width Weight PackageQuantity PartNumber ProductGroup ProductTypeName Publisher URL Studio Title)
	  end

	  def output_results
	  	@final_object = {}
	  	@upcs.each_with_index do |upc, i|
	  		@final_object.merge!(upc[0] => @output_object[i])
	  	end
	  	@final_object
	  end

	end

	module Tools

		class << self

			def to_string_representation_of_hash params
				"{" + params.map { |k, v| "'#{k}'=>'#{v}'" }.join(",") + "}"
			end

			def write_to_file hash_vals
				CSV.open("values.txt", "a+", { force_quotes: true } ) do |row|
					hash_vals.each_pair do |upc, url|
						row << [upc, url]
					end

				end

			end

		end

	end

end

b = Request::Builder.new
b.send_data