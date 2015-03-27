hunting_locations ||= @hunting_locations
json.array!(hunting_locations) do |hunting_location|
  json.partial! hunting_location
end
