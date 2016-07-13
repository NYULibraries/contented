FactoryGirl.define do
  factory :peoplesync, class: Hash do
    skip_create

    send :"NetID", "xx123"
    send :"Employee_ID", "N1234"
    send :"Last_Name", "Robot"
    send :"First_Name", "Mr"
    send :"Primary_Work_Space_Address", "10 Number Place"
    send :"Work_Phone", "+1 (555) 5555555"
    send :"Email_Address", "lib-no-reply@nyu.edu"
    send :"All_Positions_Jobs" do
      [
        {
           Job_Profile: "000000 - Some Job Profile",
           Is_Primary_Job: "1",
           Job_Family_Group: "NYU - Something",
           Supervisory_Org_Name: "LITS & Media Services",
           Business_Title: "Web Administrator",
           Position_Work_Space: "New York > Bobst Library > LITS > Web Services",
           Division_Name: "Division of Libraries"
        }
      ]
    end

    factory :peoplesync_with_unmapped_location do
      send :"All_Positions_Jobs" do
        [
          {
             Job_Profile: "000000 - Some Job Profile",
             Is_Primary_Job: "1",
             Job_Family_Group: "NYU - Something",
             Supervisory_Org_Name: "LITS & Media Services",
             Business_Title: "Web Administrator",
             Position_Work_Space: "New York > Unmapped location > LITS > Web Services",
             Division_Name: "Division of Libraries"
          }
        ]
      end
    end

    initialize_with { attributes }
  end
end
