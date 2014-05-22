#!/usr/bin/env ruby

require 'opener/daemons'
require_relative '../lib/opener/scorer'

options = Opener::Daemons::OptParser.parse!(ARGV)
daemon  = Opener::Daemons::Daemon.new(Opener::Scorer, options)

daemon.start