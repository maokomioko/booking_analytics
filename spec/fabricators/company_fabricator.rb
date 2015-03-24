Fabricator(:company) do
  name { FFaker::Company.name }
  wb_auth { true }
  owner { Fabricate(:user) }
end
