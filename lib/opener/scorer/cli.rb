module Opener
  class Scorer
    ##
    # CLI wrapper around {Opener::Scorer} using Slop.
    #
    # @!attribute [r] parser
    #  @return [Slop]
    #
    class CLI
      attr_reader :parser

      def initialize
        @parser = configure_slop
      end

      ##
      # @param [Array] argv
      #
      def run(argv = ARGV)
        parser.parse(argv)
      end

      ##
      # @return [Slop]
      #
      def configure_slop
        return Slop.new(:strict => false, :indent => 2, :help => true) do
          banner 'Usage: scorer [OPTIONS]'

          separator <<-EOF.chomp

About:

    Calculates and stores a score in MySQL based on an input KAF document.
    This command reads input from STDIN.

Example:

    cat some_file.kaf | scorer
          EOF

          separator "\nOptions:\n"

          on :v, :version, 'Shows the current version' do
            abort "scorer v#{VERSION} on #{RUBY_DESCRIPTION}"
          end

          run do |opts, args|
            scorer = OutputProcessor.new
            input  = STDIN.tty? ? nil : STDIN.read
            output = scorer.process(input)

            puts JSON.dump(output)
          end
        end
      end
    end # CLI
  end # Scorer
end # Opener
