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

      before(:each) do
        classifier.train("French", "Le renard brun rapide saute par-dessus le chien paresseux")
        classifier.train("Latin", "Brunneis vulpes salit super piger canis vivorum")
        classifier.train("Filipino", "Ang mabilis na brown soro jumps sa ibabaw ng tamad na aso")
        classifier.train("Hungarian", "A gyors barna róka átugorja a lusta kutyát")
        classifier.train("Afrikaans", "Die vinnige bruin jakkals spring oor die lui hond")
      end

      it "should return 'English' when given an English document" do
        classifier.classify("The lazy dog jumps over the quick brown fox").should eq("English")
      end

      it "should return 'Latin' when given a Latin document" do
        classifier.classify("Vivos brunneis vulpes salit super piger canis").should eq("Latin")
      end

      it "should return 'Filipino' given a Filipino document" do
        classifier.classify("Ang tamad na aso jumps sa ibabaw ng mabilis na brown soro").should eq("Filipino")
      end

      it "should return 'French' given a French document" do
        classifier.classify("Le chien paresseux saute par-dessus le renard brun rapide").should eq("French")
      end

      it "should return 'Hungarian' given a Hungarian document" do
        classifier.classify("A lusta kutya átugorja a gyors barna róka").should eq("Hungarian")
      end

      it "should return 'Afrikaans' given a Afrikaans document" do
        classifier.classify("Die lui hond spring oor die vinnige bruin jakkals").should eq("Afrikaans")
      end

    end

  end
end