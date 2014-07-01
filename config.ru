require File.expand_path('../lib/opener/scorer', __FILE__)
require File.expand_path('../lib/opener/scorer/server', __FILE__)

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run Opener::Scorer::Server
