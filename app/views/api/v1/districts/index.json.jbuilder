json.success true
json.provinces @provinces do |pro|
  json.code pro.code
  json.name pro.name
  json.cities pro.cities do |city|
    json.code city.code
    json.name city.name
  end
end