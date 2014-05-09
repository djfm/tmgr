json.array!(@projects) do |project|
  json.extract! project, :id, :title, :deadline, :comments
  json.url project_url(project, format: :json)
end
