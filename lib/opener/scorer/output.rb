require 'active_record'

module Opener
  class Outlet
    class Output < ActiveRecord::Base
       attr_accessible :uuid, :text

       validates_uniqueness_of :uuid
    end
  end
end

