Fabricator(:company) do
  name { FFaker::Company.name }
  owner { Fabricate(:user) }
end
