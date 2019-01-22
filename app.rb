require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'scrapper.rb'

Scrapper.get_townhall_urls
Scrapper.save_as_json
Scrapper.save_as_csv
Scrapper.save_as_spreadsheet