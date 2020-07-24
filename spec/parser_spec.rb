require_relative '../log_parser.rb'
require 'rspec'
require 'tempfile'

RSpec.describe LogParser do

  context "when a log file is given" do
    let(:test_log_file) { Tempfile.new(['test', '.log']) }
    let(:argument) { test_log_file.path }

    subject { described_class.new(argument).run }

    after do 
      test_log_file.unlink
    end
      
    it "can read it" do
      expect(subject).to eq({})
    end

    it "gives the user a helpful error message if it cannot be parsed" do
      test_log_file.write("this is not a server log file, just some random strings")
      test_log_file.rewind

      expect(subject).to eq("This is not a valid log file, please check the formatting and try again.")
    end

    # it "will read each line" do
    #   pending
    # end

    # it "will add each line to a hash" do
    #   pending
    # end

    # it "will process the hash and display a list of urls with number of visits" do
      
    # end

    # it "will process the hash and display a list of urls with number of uniq visits" do
      
    # end
  end

  context "when another kind of file is given" do
    it "will send the user an error if the file is not a log file" do
      pending
    end
  end

  context "when there is an empty log file" do
    it "will send the user an error if the file is empty" do
      pending
    end
  end

  context "when there is more than one argument in the shell" do
    it "will send the user an error" do
      pending
    end
  end
end