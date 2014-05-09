json.array!(@resources) do |resource|
  json.extract! resource, :id, :title
  json.url resource_url(resource, format: :json)
end
