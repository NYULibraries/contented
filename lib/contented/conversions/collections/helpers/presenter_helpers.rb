module Contented
  module Conversions
    module Collections
      module Helpers
        # Renderer for presenters in collections
        module PresenterHelpers
          def render
            rendered_output = ''
            (method_output_order).each do |method_sym|
              rendered_output = "#{rendered_output}#{send(method_sym)}\n"
            end
            rendered_output
          end

          def method_output_order
<<<<<<< HEAD
            [
              :yaml_start,
              :subtitle,
              :job_title,
              :location,
              :address,
              :space,
              :parentdepartment,
              :departments,
              :status,
              :subjectspecialties,
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
              :first_name,
              :last_name,
              :sort_title,
              :yaml_end,
              :about_block
            ]
=======
            @method_output_order ||= [:yaml_start,
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
>>>>>>> Add list for yaml output
          end

          def wrap_in_quotes(raw=nil)
            "'#{raw.gsub(/'/,'\'\'')}'" unless raw.nil? || raw == ''
          end
        end
      end
    end
  end
end
