require 'nokogiri'

module Opener
  class Scorer
    ##
    # Class that given a raw xml input, it will calculate the overall sentiment
    # score and the scores per topic, given that it is a valid KAF document.
    #
    # @!attribute [r] input
    #  @return [String]
    #
    # @!attribute [r] lemmas_array
    #  @return [Array]
    #
    # @!attribute [r] lemmas_hash
    #  @return [Hash]
    #
    # @!attribute [r] polarities_hash
    #  @return [Hash]
    #
    class OutputProcessor
      attr_accessor :input, :lemmas_array, :lemmas_hash, :polarities_hash

      ##
      # @param [String] input
      #
      def initialize(input)
        @input = Nokogiri::XML::Document.parse(input)
        @lemmas_array = []
        @lemmas_hash = {}
        @polarities_hash = {}
      end

      ##
      # Process the document and return the scores for the available topics.
      #
      # @return [Hash]
      #
      def process
        scores = {}

        build_lemmas_hash
        build_polarities_hash

        if overall_score = get_overall_score
          scores[:overall] = overall_score
        end

        lemmas_hash.keys.each do |topic|
          score = get_topic_score(topic)
          if score
            scores[topic] = score
          end
        end

        return scores
      end

      protected

      ##
      # Create a hash with all lemma ids per property and also an array with
      # all lemma ids.
      #
      def build_lemmas_hash
        input.css('features properties property').each do |property|
          lemma = property.attr('lemma').to_sym
          lemmas_hash[lemma] ||= []
          property.css('references target').each do |target|
            lemma_id = target.attr('id')
            lemmas_array << lemma_id
            lemmas_hash[lemma] << lemma_id
          end
        end
      end

      ##
      # Create a hash with all lemma ids that have a polarity.
      #
      def build_polarities_hash
        if opinions = input.at('opinions')
          opinions.css('opinion').each do |opinion|
            polarity = opinion.at('opinion_expression').attr('polarity').to_sym
            strength = opinion.at('opinion_expression').attr('strength').to_i.abs
            
            if targets = opinion.at('opinion_target')
              targets.css('span target').each do |target|
                polarities_hash[target.attr('id')] ||= {}
                polarities_hash[target.attr('id')][polarity] = strength
              end
            end
            
            if expressions = opinion.at('opinion_expression')
              expressions.css('span target').each do |expression|
                polarities_hash[expression.attr('id')] ||= {}
                polarities_hash[expression.attr('id')][polarity] = strength
              end
            end
          end
        end
      end

      ##
      # Get the score for all lemmas that have a polarity.
      #
      # @return [Float]
      #
      def get_overall_score
        score = 0
        polarities = {}
        polarities[:positive] = []
        polarities[:negative] = []
        if opinions = input.at('opinions')
          input.at('opinions').css('opinion').each do |opinion|
            sentiment = opinion.at('opinion_expression').attr('polarity').to_sym
            polarities[sentiment] << opinion.at('opinion_expression').attr('strength').to_i.abs
          end
        
          positive = polarities[:positive].inject(0, :+)
          negative = polarities[:negative].inject(0, :+)
        
          return if (positive + negative) == 0
        
          score = ((positive - negative).to_f) / (positive + negative)
        end
        return score     
      end

      ##
      # Given a topic, return the sentiment score of the lemmas of this topic.
      #
      # @return [Float] || [NilClass]
      #
      def get_topic_score(topic)
        return calculate_score(lemmas_hash[topic]) if lemmas_hash[topic]
      end

      ##
      # Given an array of lemma ids, calculate the sentiment score.
      #
      # @return [Float]
      #
      def calculate_score(lemma_ids)
        positive_polarities = []
        negative_polarities = []
        
        lemma_ids.each do |id|
          positive_polarities << polarities_hash[id].fetch(:positive, 0)
          negative_polarities << polarities_hash[id].fetch(:negative, 0)
        end     
        
        positive = positive_polarities.compact.inject(0, :+)
        negative = negative_polarities.compact.inject(0, :+)
        
        return if (positive + negative) == 0

        score = ((positive - negative).to_f) / (positive + negative)

        return score
      end

    end # OutputProcessor
  end # Scorer
end # Opener
