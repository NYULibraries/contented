module Contented
  module Conversions
    module Collections
      module Helpers
        # Yaml front matter field creators such as collections and list
        module MarkdownFieldHelpers
          def to_yaml_list(str)
            "\n#{close_open_quotes(str).split(by_semicolon_if_not_in_single_quotes).collect { |item| "  - #{wrap_in_single_quotes(item.strip)}" }.join("\n")}" unless str.to_s.empty?
          end

          def to_yaml_object(str)
            "\n#{close_open_quotes(str).split(by_semicolon_if_not_in_single_quotes).collect { |item| "  #{close_open_quotes(item.strip)}" }.join("\n")}" unless str.to_s.empty?
          end

          def yaml_remove_start(yaml_str)
            yaml_str[4..-1]
          end

          # http://stackoverflow.com/questions/11502598/how-to-match-something-with-regex-that-is-not-between-two-special-characters#11503678
          def by_semicolon_if_not_in_single_quotes
            /;(?=(?:[^']*'[^']*')*[^']*\Z)/
          end

          # Strip single quotes if they exist
          # and wrap string in single quotes
          #
          # Ex.
          # wrap_in_single_quotes("'im wrapped up'") => 'im wrapped up'
          # wrap_in_single_quotes("im so cold") => 'im so cold'
          def wrap_in_single_quotes(str)
            "'#{ascii_string(str.chomp("'").reverse.chomp("'").reverse)}'"
          end

          def close_open_quotes(str)
            (str.count("'")%2 != 0) ? "#{ascii_string(str)}'" : ascii_string(str)
          end

          def ascii_string(non_ascii_string)
            encoding_options = {
              :invalid           => :replace,  # Replace invalid byte sequences
              :undef             => :replace,  # Replace anything not defined in ASCII
              :replace           => '',        # Use a blank for those replacements
              :universal_newline => true       # Always break lines with \n
            }
            non_ascii_string.encode(Encoding.find('ASCII'), encoding_options)
          end
        end
      end
    end
  end
end
