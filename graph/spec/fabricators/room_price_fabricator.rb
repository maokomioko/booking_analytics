Fabricator(:room_price) do
  date { Date.today }
  price_cents { rand(1000..150000) }
end
