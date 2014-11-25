#!/usr/bin/env ruby

require 'opener/daemons'

require_relative '../lib/opener/scorer'

daemon = Opener::Daemons::Daemon.new(Opener::Scorer::OutputProcessor)

daemon.start
