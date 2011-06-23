require 'spec_helper'

# This is a simple set of tests to make sure that
# all trackers conform to basic requirements.

Trackablaze::Tracker.trackers.each do |tracker_handle, tracker_class|
  describe tracker_class do
    describe 'basics' do
      it("should have a handle"){ tracker_class.handle.should be_kind_of(String); tracker_class.handle.should_not be_empty } 
    end
    
    describe 'tracker configuration yml' do 
      it("should should exist (#{tracker_class.handle}.yml)") { tracker_class.info.should_not be_nil; }
      it("should be a hash"){ tracker_class.info.should be_kind_of(Hash); } 
    end
    
    describe 'tracker configuration' do
      it("should have params hash"){ tracker_class.info['params'].should be_kind_of(Hash); } 
      it("should have metrics hash"){ tracker_class.info['metrics'].should be_kind_of(Hash); } 
    end
    
    describe 'tracker params' do
      tracker_class.info['params'].each do |param_name, param_config|
        describe "param #{param_name}" do
          it("should have a name"){ param_config['name'].should be_kind_of(String); param_config['name'].should_not be_empty }
          it("should have a description"){ param_config['description'].should be_kind_of(String); param_config['description'].should_not be_empty }
        end
      end
    end

    describe 'tracker metrics' do
      tracker_class.info['metrics'].each do |metric_name, metric_config|
        describe "metric #{metric_name}" do
          it("should have a name"){ metric_config['name'].should be_kind_of(String); metric_config['name'].should_not be_empty }
        end
      end
    end

    describe 'tracker interface' do
      ['get_metrics'].each do |method_name|
        it("should have method #{method_name}"){ tracker_class.new.should respond_to(method_name) }
      end
      
      it("get_metrics should return empty array when given an empty array"){ tracker_class.new.get_metrics([]).should == [] }
    end
  end
end