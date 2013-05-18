module LanguageClassifier
  class Classifier

    attr_reader :words, :total_documents, :total_words, :category_documents, :category_words

    def initialize
      @words ||= Hash.new
      @total_documents ||= 0
      @category_documents ||= Hash.new
    end

    def train(category, document)      
      @total_documents += 1
      @category_documents[category] ||= 0
      @category_documents[category] += 1

      @words[category] ||= Hash.new
      document_words = document.gsub(/[^\w\s]/, "").split
      document_words.each do |document_word|
        key = document_word.downcase.stem
        @words[category][key] ||= 0
        @words[category][key] += 1
        @total_words ||= 0
        @total_words += 1
        @category_words ||= Hash.new
        @category_words[category] ||= 0
        @category_words[category] += 1
      end
    end

  end
end