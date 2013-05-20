require 'spec_helper'

describe ClassifierController do

  describe ".process" do

    let(:output) { mock('output').as_null_object }
    before(:each) { ClassifierController.process('seed', '--db', 'tmp/madeleine_for_specs', output) }
    after(:each) { ClassifierController.send(:clear, {:madeleine => 'tmp/madeleine_for_specs'}) }

    context "seed" do

      it "should fill the database with all the sample files" do
        madeleine = ClassifierController.send(:madeleine, 'tmp/madeleine_for_specs')
        madeleine.system.send(:total_documents).should eq(8)
      end

    end

    context "classify" do

      it "should classify an english document as english" do
        ClassifierController.process('classify', '-f', File.expand_path('../../', __FILE__) + "/samples/english.txt", '--db', 'tmp/madeleine_for_specs', '-q', output).should eq('english')
      end

    end

    context "train" do

      it "should store the category and document in madeleine" do
        ClassifierController.process('train', '-f', File.expand_path('../../', __FILE__) + "/samples/english.txt", '--db', 'tmp/madeleine_for_specs', '-q', '-c', 'english', output)
        madeleine = ClassifierController.send(:madeleine, 'tmp/madeleine_for_specs')
        madeleine.system.send(:total_documents).should eq(9)
      end

    end

    context "clear" do

      it "should clear out the directory where madeleine stores it's data" do
        ClassifierController.process('clear', '--db', 'tmp/madeleine_for_specs', output)
        Dir.exist?(File.expand_path('../../', __FILE__) + "tmp/madeleine_for_specs").should be_false
      end

    end

    context "method not found" do

      it "should print out instructions" do
        output.shoud_receive(:puts).with("Command not found")
        ClassifierController.process('not_found', output)
      end

    end

  end

end