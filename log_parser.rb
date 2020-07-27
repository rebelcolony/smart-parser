# frozen_string_literal: true

# log parser, to parse log files
class LogParser
  attr_accessor :log_file_path

  def initialize(args)
    if args == [] || args.length > 1 || args[0] !~ /.log/
      puts 'You need give me path to a log file if you want me to parse it.'
    else
      @log_file_path = args[0]
      @lines = File.readlines(@log_file_path)
      if @lines == []
        puts 'This file is blank, please check the formatting and try again.'
      else
        validate
      end
    end
  end

  def run
    @collection = {}
    process
    show_visitors
    show_unique_visitors
  end

  def validate
    pattern = /\/\S+ \d{1,3}[.]\d{1,3}[.]\d{1,3}[.]\d{1,3}/
    pass = true

    @lines.each do |line|
      unless pattern =~ line
        puts 'This is not a valid log file, please check the formatting and try again.'
        pass = false
        return
      end
    end

    pass == true ? run : nil
  end

  def process
    @lines.each do |line|
      @collection[line.split[0]] ||= []
      @collection[line.split[0]] << line.split[1]
    end
  end

  def show_visitors
    @collection.sort_by { |_key, value| value.count }.reverse.to_h.each { |k, v| puts "#{k} #{v.count} visits" }
  end

  def show_unique_visitors
    @collection.each_value { |value| value.uniq! }
               .sort_by { |_key, value| value.count }
               .reverse.to_h.each { |key, value| puts "#{key} #{value.count} unique visits" }
  end
end

# Make the file runnable from the command line
if $PROGRAM_NAME == __FILE__
  LogParser.new(ARGV)
end
