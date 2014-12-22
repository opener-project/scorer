require 'spec_helper'

describe Opener::Scorer::OutputProcessor do
  before :all do
    file = File.read('spec/fixtures/review_output.kaf')
    @processor = Opener::Scorer::OutputProcessor.new
    @result = @processor.process(file)
  end

  context 'output processor' do

    example 'output returns a Hash' do
      @result.is_a?(Hash).should == true      
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
  end
end
