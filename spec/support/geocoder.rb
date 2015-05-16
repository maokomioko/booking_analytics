Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
    [
        {
            'latitude'     => 40.7143528,
            'longitude'    => -74.0059731,
            'address'      => 'New York, NY, USA',
            'state'        => 'New York',
            'state_code'   => 'NY',
            'country'      => 'United States',
            'country_code' => 'US',
            'districts'    => ['Praha 1']
        }
    ]
)

PRAGUE_ADDRESSES = [["Palackeho 2/5", 50.081089, 14.422819, ["Praha 1"]],
 ["Doudova 22", 50.056702, 14.426508, ["Praha 4"]],
 ["Ve studenem 1358/6", 50.030055, 14.423635, ["Praha 4"]],
 ["Mostecka 11", 50.087243, 14.405728, ["Praha 1"]],
 ["Marie Cibulkove 8", 50.059498, 14.427261, ["Praha 4"]],
 ["Kloboucnicka 1411/26", 50.062438, 14.449503, ["Praha 4"]],
 ["Náchodská 708/79", 50.115044, 14.607418, ["Praha 20"]],
 ["U Nemocenské Pojišťovny 2", 50.092306, 14.431015, ["Praha 1"]],
 ["Lisabonska 606/10", 50.105812, 14.497589, ["Praha 9"]],
 ["Karlštejnská 494/17", 50.053673, 14.360124, ["Praha 5"]],
 ["Cimicka 150a", 50.139404, 14.430498, ["Praha 8"]],
 ["Drahobejlova 1058/17", 50.104982, 14.487205, ["Praha 9"]],
 ["Fričova 9", 50.067431, 14.435862, ["Praha 2"]],
 ["Ašská 107", 50.137424, 14.519174, ["Praha 18"]],
 ["Kolbenova 159/5", 50.110847, 14.507958, ["Praha 9"]],
 ["Hybernská 12", 50.087089, 14.431378, ["Praha 1"]],
 ["K sopce 30", 50.045099, 14.344305, ["Praha 13"]],
 ["Tachovské náměstí 6/288", 50.087543, 14.45343, ["Praha 3"]],
 ["Mládeže 1375/7", 50.085271, 14.372561, ["Praha 6"]],
 ["U Národní galerie 474", 49.977202, 14.394189, ["Praha-Zbraslav"]]]

PRAGUE_ADDRESSES.each do |(address, latitude, longitude, districts)|
  Geocoder::Lookup::Test.add_stub(
    "Prague, #{ address }", [
      {
        'latitude'     => latitude,
        'longitude'    => longitude,
        'address'      => 'Prague, ' + address,
        'country'      => 'Czech Republic',
        'country_code' => 'CZ',
        'districts'    => districts
      }
    ]
  )
end