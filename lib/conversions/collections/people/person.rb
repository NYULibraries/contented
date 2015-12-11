require 'json'

module Conversions
  module Collections
    module People
      # Edits the Peoplesync attributes to make them look like spreadsheet JSON
      class Person
        attr_accessor :netid, :last_name, :first_name, :work_phone, :email_address, :all_positions_jobs, :backup_title

        def initialize(json_data)
          JSON.parse(json_data).each_pair { |var, val| self.send("#{var.downcase}=", val) if respond_to?(var.downcase) && !val.empty? }
          @all_positions_jobs = [] unless @all_positions_jobs
          @backup_title = "#{first_name} #{last_name}" if first_name && last_name
        end
      end
    end
  end
end
