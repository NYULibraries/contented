namespace :contented do
  namespace :convert do
    desc 'Converts people into markdown'
    task :people do |task|
      #
    end

    desc 'Convert departments from GatherContent JSON to Markdowns with YAML Front Matter'
    task :departments do
      departments = GatherContent::Departments.new(project_id = '57459')
      departments.each do |department|
        if department.published?
          puts "Writing '#{department.title}' to #{department.filename}.markdown..."
          File.write("#{department.filename}.markdown", department.to_markdown)
        end
      end
    end
  end
end
