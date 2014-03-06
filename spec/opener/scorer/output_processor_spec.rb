require 'spec_helper'

describe Opener::Scorer::OutputProcessor do
  before :all do
    file = File.read('spec/fixtures/review_output.kaf')
    @processor = Opener::Scorer::OutputProcessor.new(file)
    @result = @processor.process
  end

  context 'output processor' do

    example 'output returns a Hash' do
      @result.is_a?(Hash).should == true      
    end
    
    example 'lemmas array returns correct values' do
      lemmas_array = ["t2"]
      (@processor.lemmas_array - lemmas_array).empty?.should == true    
    end
    
    example 'lemmas hash returns correct values' do
      properties = {:internet => ["t2"]}
      @processor.lemmas_hash.should == properties    
    end
    
    example 'result returns correct internet score' do
      @result[:internet].should == -1   
    end
    
    example 'result returns correct overall score' do
      @result[:overall].should == -1   
    end
    
    example 'result returns only properties that have a score' do
      @result.keys.sort.should == [:internet, :overall]   
    end
    
    example 'result returns only properties that have a score' do
      @processor.polarities_hash["t1"].should == [:negative]
    end  
    
  end
end
