class DumpReader

	def initialize
		@file = "../../upc.txt"
		@total_lines = File.readlines(@file).size
	end

	def next_set
		@start += 8
		@end += 8
	end

	def build_hash
		options = File.readlines(@file)[@start..@end].each_with_index.map do |upc, i|
			options = Hash.new if options = {}
			options.merge!("IdList.Id.#{i + 1}".strip => upc.strip)
		end
	end

	def increment
		if first_set?
			initialize_counter
		elsif last_set?
			set_last_rows
		else
			next_set
		end
	end

	def current_end_row
		@end
	end

	def last_row
		@total_lines
	end


	def set_last_rows
		@start = @end + 1
		@end = @total_lines
	end

	def initialize_counter
		@start = 0
		@end = @total_lines > 8 ? 8 : @total_lines
	end

	def last_set?
		@end && @end + 8 > @total_lines
	end

	def first_set?
		!defined? @start
	end

end