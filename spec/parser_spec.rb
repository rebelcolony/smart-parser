require_relative '../log_parser.rb'
require 'rspec'
require 'tempfile'

RSpec.describe LogParser do
  context 'with no file passed as an argument' do
    subject { described_class.new([]) }

    it 'will output a helpful error message' do
      expect { subject }.to output("You need give me path to a log file if you want me to parse it.\n").to_stdout
    end
  end

  context 'with any file passed as an argument' do
    let(:test_log_file) { Tempfile.new(['test', '.log']) }
    let(:argument) { [test_log_file.path] }

    subject { described_class.new(argument) }

    after do
      test_log_file.unlink
    end

    it 'can read it without exception' do
      expect(subject.class).to eq(described_class)
    end
  end

  context 'with a log file that is not formatted corectly' do
    let(:test_log_file) { Tempfile.new(['test', '.log']) }
    let(:argument) { [test_log_file.path] }

    subject { described_class.new(argument) }

    it 'gives the user a helpful error message if it cannot be parsed' do
      test_log_file.write("this is not a server log file, just some random strings")
      test_log_file.rewind

      expect { subject }.to output("This is not a valid log file, please check the formatting and try again.\n").to_stdout
    end
  end

  context 'with a properly formatted log file' do
    let(:test_log_file) { Tempfile.new(['test', '.log']) }
    let(:argument) { [test_log_file.path] }

    after do
      test_log_file.unlink
    end

    it 'will output something to the console' do
      test_log_file << "/help_page/1 126.318.035.999"
      test_log_file.rewind

      expect { described_class.new(argument) }.to output("/help_page/1 1 visits\n/help_page/1 1 unique visits\n").to_stdout
    end

    it "will output the correct number of visitors and unique visitors" do
      test_log_file << "/help_page/1 126.318.035.999\n/help_page/1 126.318.035.888\n/help_page/1 126.318.035.038\n/about 127.222.888.999\n/about 127.222.888.999"
      test_log_file.rewind

      expect { described_class.new(argument) }.to output("/help_page/1 3 visits\n/about 2 visits\n/help_page/1 3 unique visits\n/about 1 unique visits\n").to_stdout
    end
  end

  context 'with a properly formatted log file that has whitespace' do
    let(:test_log_file) { Tempfile.new(['test', '.log']) }
    let(:argument) { [test_log_file.path] }

    subject { described_class.new(argument) }

    after do 
      test_log_file.unlink
    end

    it 'will not pass validation' do
      test_log_file << "/help_page/1 126.318.035.038\n/help_page/1 126.318.035.038\n/help_page/1 126.318.035.038\n\n\n\n/help_page/1 126.318.035.038"
      test_log_file.rewind

      expect { subject }
        .to output("This is not a valid log file, please check the formatting and try again.\n").to_stdout
    end
  end

  context 'when another kind of file is given' do
    let(:test_log_file) { Tempfile.new(['test', '.txt']) }
    let(:argument) { [test_log_file.path] }

    subject { described_class.new(argument) }

    after do
      test_log_file.unlink
    end

    it 'will send the user an error if the file is not a log file' do
      test_log_file << "/help_page/1 126.318.035.038\n/help_page/1 126.318.035.038\n/help_page/1 126.318.035.038\n\n\n\n/help_page/1 126.318.035.038"
      test_log_file.rewind

      expect { subject }.to output("You need give me path to a log file if you want me to parse it.\n").to_stdout
    end
  end

  context 'when there is an empty log file' do
    let(:test_log_file) { Tempfile.new(['test', '.log']) }
    let(:argument) { [test_log_file.path] }

    subject { described_class.new(argument) }

    after do
      test_log_file.unlink
    end

    it 'will send the user an error' do
      expect { subject }.to output("This file is blank, please check the formatting and try again.\n").to_stdout
    end
  end

  context 'when there is more than one argument in the shell' do
    let(:test_log_file1) { Tempfile.new(['test', '.log']) }
    let(:test_log_file2) { Tempfile.new(['test', '.log']) }

    let(:arguments) { [test_log_file1.path, test_log_file1.path] }

    after do
      test_log_file1.unlink
      test_log_file2.unlink
    end

    it 'will send the user an error' do
      expect { described_class.new(arguments) }
        .to output("You need give me path to a log file if you want me to parse it.\n").to_stdout
    end
  end
end
