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
      word_count(document).each do |key, count|
        @words[category][key] ||= 0
        @words[category][key] += count
        @total_words ||= 0
        @total_words += count
        @category_words ||= Hash.new
        @category_words[category] ||= 0
        @category_words[category] += count
      end
    end

    def classify(document)
      sorted = probabilities(document).sort { |a, b| a[1]<=>b[1] }
      return sorted.pop[0]
    end

    private

    def probabilities(document)
      probabilities = Hash.new
      @words.each_key do |category|
        probabilities[category] = probability(category, document)
      end
      return probabilities
    end

    def probability(category, document)
      doc_probability(category, document) * category_probability(category)
    end

    def category_probability(category)
      @category_documents[category].to_f/@total_documents.to_f
    end

    def doc_probability(category, document)
      doc_prob = 1
      word_count(document).each { |word| doc_prob *= word_probability(category, word[0]) }
      return doc_prob
    end

    def word_probability(category, word)
      (@words[category][word.stem].to_f + 1)/@category_words[category].to_f
    end

    def word_count(document)
      document_words = document.gsub(/[^\w\s]/, "").split
      d = Hash.new

      document_words.each do |document_word|
        key = document_word.downcase.stem
        d[key] ||= 0
        d[key] += 1
      end

      return d
    end

  end
end