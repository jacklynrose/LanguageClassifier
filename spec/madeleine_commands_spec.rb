require 'spec_helper'

describe MadeleineCommands do
  describe ".train_command" do
    it "should return a command object that calls 'train' when executed" do
      sys = mock("system")
      sys.should_receive(:train).with("test", "test")
      MadeleineCommands.train_command("test", "test").execute(sys)
    end  
  end

  describe ".classify_query" do
    it "should return a query object that calls 'classify' when executed" do
      sys = mock("system")
      sys.should_receive(:classify).with("test")
      MadeleineCommands.classify_query("test").execute(sys)
    end  
  end
end