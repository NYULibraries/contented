module Contented
  module Conversions
    module Collections
      module People
        # Edits the Peoplesync attributes to make them look like spreadsheet JSON
        class Person
          attr_accessor :netid, :last_name, :first_name, :work_phone, :email_address, :all_positions_jobs

          def initialize(json_data)
            JSON.parse(json_data).each_pair { |var, val| send("#{var.downcase}=", val) if respond_to?(var.downcase) && !val.empty? }
            @all_positions_jobs = [] unless @all_positions_jobs
          end
        end
      end
    end
  end
end
