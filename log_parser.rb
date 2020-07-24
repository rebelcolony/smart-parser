# take a user generated log file
# parse the file and for each line add to a hash url => ip_array
# process hash to calculate the ordered list with the most views
# call .uniq on the hash and calculate the views again
# unit tests for step 1, 2, 3
# awk as a suggestion 

# /home 90 visits
# /about 6 visits

class LogParser
  attr_accessor :log_file_path

  def initialize(path)
    @log_file_path = path
  end

  def run
    lines = File.readlines(@log_file_path)

    # # validate each line
    # pattern = /\/\S+ \d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}/  
    # lines.each do |line|
    #   pattern =~ line
    # end

    visitors = {}

    lines.each_with_index do |line|
      visitors[ line.split[0] ] ||= [] 
      visitors[ line.split[0] ] << line.split[1]
    end

    sorted = visitors.sort_by {|key, value| value.count }.reverse!.to_h

    sorted.each do |key, value|
      puts "#{key} #{value.count} visits"
    end

    puts "=="

    uniqe_visitors = visitors.each_value { |value| value.uniq! }
    uniqe_sorted = uniqe_visitors.sort_by {|key, value| value.count }.reverse!.to_h

    uniqe_sorted.each do |key, value|
      puts "#{key} #{value.count} uniqe visits"
    end
  end  
end

# Make the file runnable from the command line
if $PROGRAM_NAME == __FILE__
  LogParser.new(ARGV).run
end