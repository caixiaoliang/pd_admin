json.success true
json.provinces  @provinces do |pro|
  json.code pro.code
  json.name pro.name
  json.cities pro.dealer_cities do |city|
    json.code city.code
    json.name city.name
    json.dealers city.dealers do |dealer|
      json.name dealer.name
      json.id dealer.id
    end
  end
end