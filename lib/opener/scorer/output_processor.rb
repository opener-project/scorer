module Opener
  class Scorer
    ##
    # Class that given a raw xml input, it will calculate the overall sentiment
    # score and the scores per topic, given that it is a valid KAF document.
    #
    # @!attribute [r] request_id
    #  @return [String]
    #
    class OutputProcessor
      attr_reader :request_id

      ##
      # @param [Hash] options
      #
      # @option options [Symbol] :request_id
      #
      def initialize(options = {})
        @request_id = options[:request_id]
      end

      ##
      # Runs the processor and returns the results as a String.
      #
      # @param [String] input
      # @return [String]
      #
      def run(input)
        output      = Output.new
        output.uuid = request_id
        output.text = JSON.dump(process(input))

        output.save!

        return output.text
      end

      ##
      # Process the document and return the scores for the available topics.
      #
      # @return [Hash]
      #
      def process(input)
        document = Nokogiri::XML(input)
        scores   = {}

        lemmas_hash     = build_lemmas_hash(document)
        polarities_hash = build_polarities_hash(document)
        overall_score   = get_overall_score(document)

        if overall_score
          scores[:overall] = overall_score
        end

        lemmas_hash.keys.each do |topic|
          score = get_topic_score(topic, lemmas_hash, polarities_hash)

          if score
            scores[topic] = score
          end
        end

        return scores
      end

      protected

      ##
      # @param [Nokogiri::XML::Document] document
      # @return [Hash]
      #
      def build_lemmas_hash(document)
        lemmas_hash  = Hash.new { |hash, key| hash[key] = [] }

        document.css('features properties property').each do |property|
          lemma = property.attr('lemma').to_sym

          property.css('references target').each do |target|
            lemma_id = target.attr('id')

            lemmas_hash[lemma] << lemma_id
          end
        end

        return lemmas_hash
      end

      ##
      # Create a hash with all lemma ids that have a polarity.
      #
      # @param [Nokogiri::XML::Document] document
      # @return [Hash]
      #
      def build_polarities_hash(document)
        polarities_hash = Hash.new { |hash, key| hash[key] = [] }
        opinions        = document.at('opinions')

        return polarities_hash unless opinions

        opinions.css('opinion').each do |opinion|
          polarity  = opinion.at('opinion_expression').attr('polarity').to_sym
          op_target = opinion.at('opinion_target')
          op_expr   = opinion.at('opinion_expression')

          if op_target
            op_target.css('span target').each do |target|
              polarities_hash[target.attr('id')] << polarity
            end
          end

          if op_expr
            op_expr.css('span target').each do |target|
              polarities_hash[target.attr('id')] << polarity
            end
          end
        end

        return polarities_hash
      end

      ##
      # Get the score for all lemmas that have a polarity.
      #
      # @param [Nokogiri::XML::Docuemnt] document
      # @return [Float]
      #
      def get_overall_score(document)
        polarities = []
        opinions   = document.at('opinions')

        return 0.0 unless opinions

        opinions.css('opinion').each do |opinion|
          polarities << opinion.at('opinion_expression').attr('polarity').to_sym
        end

        positive = polarities.count(:positive)
        negative = polarities.count(:negative)

        return if (positive + negative) == 0

        return ((positive - negative).to_f) / (positive + negative)
      end

      ##
      # Given a topic, return the sentiment score of the lemmas of this topic.
      #
      # @param [String] topic
      # @param [Hash] lemmas_hash
      # @param [Hash] polarities_hash
      # @return [Float]
      #
      def get_topic_score(topic, lemmas_hash, polarities_hash)
        if lemmas_hash[topic].empty?
          return 0.0
        else
          return calculate_score(lemmas_hash[topic], polarities_hash)
        end
      end

      ##
      # Given an array of lemma ids, calculate the sentiment score.
      #
      # @param [Array] lemma_ids
      # @param [Hash] polarities_hash
      # @return [Float]
      #
      def calculate_score(lemma_ids, polarities_hash)
        polarities = []

        lemma_ids.each do |id|
          polarities << polarities_hash[id]
        end

        positive = polarities.flatten.count(:positive)
        negative = polarities.flatten.count(:negative)

        return if (positive + negative) == 0

        score = ((positive - negative).to_f) / (positive + negative)

        return score
      end

    end # OutputProcessor
  end # Scorer
end # Opener
