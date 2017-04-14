json.success true
json.serials @serials do |serial|
  json.name serial.name
  json.id serial.id
  json.models serial.models do |model|
    json.nick_name model.name
    json.id model.id
  end
end