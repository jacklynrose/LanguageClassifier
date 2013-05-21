require 'bigdecimal'

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
      probabilities(document).sort { |a, b| a[1]<=>b[1] }.pop[0]
    end

    private

    def probabilities(document)
      @words.keys.inject({}) { |hash, category| hash.merge({category => probability(category, document)}) }
    end

    def probability(category, document)
      BigDecimal.new(doc_probability(category, document).to_s) * BigDecimal.new(category_probability(category).to_s)
    end

    def category_probability(category)
      BigDecimal.new(@category_documents[category].to_s)/BigDecimal.new(@total_documents.to_s)
    end

    def doc_probability(category, document)
      word_count(document).inject(BigDecimal.new("1")) { |doc_prob, word| doc_prob *= BigDecimal.new(word_probability(category, word[0])) }
    end

    def word_probability(category, word)
      (BigDecimal.new(@words[category][word.stem].to_s) + BigDecimal.new("1"))/BigDecimal.new(@category_words[category].to_s)
    end

    def word_count(document)
      document_words(document).inject({}) { |hash, key| hash.merge({key => (hash[key] ? hash[key] + 1 : 1)}) }
    end

    def document_words(document)
      document.gsub(/[^\w\s]/, "").split.map { |w| w.downcase.stem }
    end

  end
end