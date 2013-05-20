module MadeleineCommands

  def self.train_command(category, document)
    TrainCommand.new(category, document)
  end

  def self.classify_query(document)
    self.classify_struct.new(document)
  end

  private

  def self.classify_struct
    Struct.new(:document) do
      def execute(system)
        system.classify(document)
      end
    end
  end

  class TrainCommand
    def initialize(category, document)
      @category, @document = category, document
    end

    def execute(system)
      system.train(@category, @document)
    end
  end

end