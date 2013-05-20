require 'language_classifier'
require 'madeleine_commands'

class ClassifierController

  SEED_CATEGORIES = %w[afrikaans danish english filipino french hungarian latin romanian]

  def self.process(*args, output)
    options = process_options(*args, output)

    if self.respond_to?(options[:command])
      self.send(options[:command], options)
    else
      options[:output].puts "Command not found"
      options[:output].puts
      options[:output].puts "Training: bin/classify train -f FILE_PATH -c CATEGORY"
      options[:output].puts "Classification: bin/classify classify -f FILE_PATH"
      options[:output].puts "Seed: bin/classify seed"
    end
  end

  private

  def self.madeleine(location)
    SnapshotMadeleine.new(location) do
      LanguageClassifier::Classifier.new
    end
  end

  def self.process_options(*args, output)
    options = Hash.new
    options[:command] = args.first || :not_found
    options[:output] = output
    args.each do |arg|
      case arg
      when '-f'
        options[:document] = File.open(args[args.index(arg) + 1], "r").read
      when '-c'
        options[:category] = args[args.index(arg) + 1]
      when '--db'
        options[:madeleine] = args[args.index(arg) + 1]
      end
    end
    options[:madeleine] ||= 'tmp/language_classifier'
    options
  end

  def self.train(options)
    cmd = MadeleineCommands.train_command(options[:category], options[:document])
    madeleine(options[:madeleine]).execute_command(cmd)
    madeleine(options[:madeleine]).take_snapshot
  end

  def self.classify(options)
    cmd = MadeleineCommands.classify_query(options[:document])
    result = madeleine(options[:madeleine]).execute_query(cmd)
    options[:output].puts result
    result
  end

  def self.seed(options)
    SEED_CATEGORIES.each do |category|
      cmd = MadeleineCommands.train_command(category, File.open(File.expand_path('../../', __FILE__) + "/samples/#{category}.txt", "r").read)
      madeleine(options[:madeleine]).execute_command(cmd)
    end
    madeleine(options[:madeleine]).take_snapshot
  end

  def self.clear(options)
    directory_name = File.expand_path('../../', __FILE__) + "/#{options[:madeleine]}"
    if Dir.exists?(directory_name)
      Dir.entries(directory_name).each do |filename|
        File.unlink("#{directory_name}/#{filename}") if File.file?("#{directory_name}/#{filename}")
      end
      Dir.unlink(directory_name)
    end
  end

end