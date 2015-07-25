Fabricator(:subscription, class_name: "Payment::Subscription") do
  amount { rand(0..90) }
  payment_items { 3.times.map { Fabricate(:payment_item) } }
end
