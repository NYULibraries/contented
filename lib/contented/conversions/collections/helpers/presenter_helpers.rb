module Contented
  module Conversions
    module Collections
      module Helpers
        # Renderer for presenters in collections
        module PresenterHelpers
          def render
            render = ''
            (method_output_order).each do |method_sym|
              render = "#{render}#{send(method_sym)}\n"
            end
            render
          end

          def method_output_order
            [
              :yaml_start,
              :subtitle,
              :job_title,
              :library,
              :space,
              :departments,
              :status,
              :expertise,
              :liaisonrelationship,
              :linkedin,
              :email,
              :phone,
              :twitter,
              :image,
              :buttons,
              :guides,
              :publications,
              :blog,
              :keywords,
              :title,
              :yaml_end,
              :about_block
            ]
          end

          def wrap_in_quotes(raw=nil)
            "'#{raw.gsub(/'/,'\'\'')}'" unless raw.nil? || raw == ''
          end
        end
      end
    end
  end
end
