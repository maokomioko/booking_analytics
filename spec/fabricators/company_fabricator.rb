Fabricator(:company) do
  name { FFaker::Company.name }
  owner { Fabricate(:user) }
  subscriptions { [Fabricate(:subscription)] }
end
