# Smart Log Parser
Get a summary of visitor stats to your website with our smart log parser. Just pass in a correctly formatted log file and let the parser do the hard work while you grab a coffee.

----

## Notes
take a log file
parse the file and for each line add to a hash url => ip_array
process hash to calculate the ordered list with the most views
call .uniq on the hash and calculate the views again
awk as a suggestion

```
/home 90 visits
/about 6 visits
```

## Install

* Ruby 2.7.1
* gem install bundler
* bundler install

## Usage

Your log files should be in the format `url ip` similar to this
```
/index/1 123.456.789.000
/about 123.456.789.999
```

Make sure you're in the root directory and run from the shell

```
$> ruby log_parser.rb path/to/log_file.log
```