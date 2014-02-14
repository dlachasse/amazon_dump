require_relative './dump_reader.rb'

class Builder

	class << self

		def collect_upcs
			dump = DumpReader.new
			dump.build_hash
		end

	end

end