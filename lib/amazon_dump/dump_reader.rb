class DumpReader

	def initialize
		@file = "../../upc.txt"
		@total_lines = File.readlines(@file).size
	end

	def current_set
		if @end && @end + 9 > @total_lines
			@start = @end + 1
			@end = @total_lines
		elsif @start
			@start += 9
			@end += 9
		else
			@start, @end = 0, 9
		end
	end

	def build_hash
		@collection = []
		until @end == @total_lines do
			current_set
			options = File.readlines(@file)[@start..@end].each_with_index.map do |upc, i|
				i += 1
				options = Hash.new if options = {}
				options.merge!("IdList.Id.#{i}".strip => upc.strip)
			end
			@collection << options
		end
		return @collection
	end

end
