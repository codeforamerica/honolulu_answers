namespace :data do
  task :set_published => [:environment] do
    p 'Update Status All Articles to Published...'
    Article.all.each{|a| a.update_attributes(:status => 'Published')}
    p 'All Articles Set to Published'
  end

  task :add_departments => [:environment] do
    p 'Destroying All Departments...'
    Department.destroy_all

    p 'Creating Departments...'
    Department.create! :name => 'Board of Water Supply', :acronym => 'BWS'
    Department.create! :name => 'City Council', :acronym => 'CCL'
    Department.create! :name => 'Corporation Counsel', :acronym => 'COR'
    Department.create! :name => 'Budget and Fiscal Services', :acronym => 'BFS'
    Department.create! :name => 'Community Services', :acronym => 'DCS'
    Department.create! :name => 'Customer Services', :acronym => 'CSD'
    Department.create! :name => 'Design and Construction', :acronym => 'DDC'
    Department.create! :name => 'Emergency Management', :acronym => 'DEM'
    Department.create! :name => 'Emergency Services', :acronym => 'ESD'
    Department.create! :name => 'Enterprises Services', :acronym => 'DES'
    Department.create! :name => 'Environmental Services', :acronym => 'ENV'
    Department.create! :name => 'Facility Maintenance', :acronym => 'DFM'
    Department.create! :name => 'Human Resources', :acronym => 'DHR'
    Department.create! :name => 'Information Technology', :acronym => 'DIT'
    Department.create! :name => 'Parks and Recreation', :acronym => 'DPR'
    Department.create! :name => 'Planning and Permitting', :acronym => 'DPP'
    Department.create! :name => 'Medical Examiner', :acronym => 'MED'
    Department.create! :name => 'Prosecuting Attorney', :acronym => 'PAT'
    Department.create! :name => 'Transportation Services', :acronym => 'DTS'
    Department.create! :name => 'Honolulu Authority for Rapid Transit', :acronym => 'HART'
    Department.create! :name => 'Honolulu Fire Department', :acronym => 'HFD'
    Department.create! :name => 'Honolulu Police Department', :acronym => 'HPD'
    Department.create! :name => 'Liquor Commission', :acronym => 'LIQ'
    Department.create! :name => "Mayor's Office of Culture and the Arts".gsub(/'/, "'"), :acronym => 'MOCA'
    Department.create! :name => 'Neighborhood Commission Office', :acronym => 'NCO'
    Department.create! :name => 'Oahu Metropolitan Planning Organization', :acronym => 'OMPO'
    Department.create! :name => 'Office of Council Services', :acronym => 'OCS'
    Department.create! :name => 'Office of Economic Development', :acronym => 'OED'
    Department.create! :name => 'Office of Housing', :acronym => 'HOU'
    Department.create! :name => 'Office of the City Auditor', :acronym => 'OCA'
    Department.create! :name => 'Office of the City Clerk', :acronym => 'CLK'
    Department.create! :name => 'Office of the Mayor', :acronym => 'MAY'
    Department.create! :name => 'Royal Hawaiian Band', :acronym => 'RHB'
    Department.create! :name => 'Other', :acronym => 'Other'
    p 'Departments Created'
  end
end