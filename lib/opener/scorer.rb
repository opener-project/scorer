require 'json'
require 'securerandom'

require 'active_record'
require 'nokogiri'
require 'sinatra/base'
require 'slop'

require_relative 'scorer/cli'
require_relative 'scorer/output'
require_relative 'scorer/output_processor'
require_relative 'scorer/version'
require_relative 'scorer/server'
require_relative '../../config/database'
