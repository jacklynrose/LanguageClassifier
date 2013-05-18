require 'spec_helper'

module LanguageClassifier
  describe Classifier do

    let(:classifier) { Classifier.new }
    before(:each) { classifier.train("English", "The quick brown fox jumps over the lazy dog") }

    describe "#train" do

      context "no previous training for category" do

        it "should add the category to the list of categories" do
          classifier.words.keys.should include("English")
        end

      end

      it "should add the count for each word in the document to the category" do
        classifier.train("English", "The lazy dog jumps over the quick brown fox")
        classifier.words["English"]["quick"].should eq(2)
      end

      it "should add the count for all words to the total words" do
        classifier.total_words.should eq(9)
      end

      it "should add the count for all words to the total words in the cateogry" do
        classifier.category_words["English"].should eq(9)
      end

      it "should increment the number of documents in the category by one" do
        classifier.category_documents["English"].should eq(1)
      end

      it "should increment the number of total documents by one" do
        classifier.total_documents.should eq(1)
      end

    end

    describe "#classify" do

      it "should return 'English' when given an English document" do
        classifier.train("French", "Le renard brun rapide saute par-dessus le chien paresseux")
        classifier.train("Latin", "Brunneis vulpes salit super piger canis vivorum")
        classifier.train("Filipino", "Ang mabilis na brown soro jumps sa ibabaw ng tamad na aso")

        classifier.classify("The lazy dog jumps over the quick brown fox").should eq("English")
      end

      it "should return 'Latin' when given an Latin document" do
        classifier.train("French", "Le renard brun rapide saute par-dessus le chien paresseux")
        classifier.train("Latin", "Brunneis vulpes salit super piger canis vivorum")
        classifier.train("Filipino", "Ang mabilis na brown soro jumps sa ibabaw ng tamad na aso")

        classifier.classify("Vivos brunneis vulpes salit super piger canis").should eq("Latin")
      end

    end

  end
end