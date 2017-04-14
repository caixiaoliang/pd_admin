json.success true
json.cities  @cities do |city|
  json.code city.code
  json.name city.name
end 