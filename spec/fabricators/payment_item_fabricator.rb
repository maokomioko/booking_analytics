Fabricator(:payment_item, class_name: "Payment::PaymentItem") do
  name { FFaker::Lorem.word }
  price { rand(10..90) }
end
