require 'active_record'

module Opener
  class Scorer
    class OutputScore < ActiveRecord::Base
       attr_accessible :uuid, :raw_text, :bathroom, :breakfast, :cleanliness, 
         :facilities, :internet, :location, :noise, :parking, :restaurant,
          :room, :sleeping_comfort, :staff, :swimming_pool, :value_for_money,
          :overall
       
       validates_uniqueness_of :uuid
    end
  end
end