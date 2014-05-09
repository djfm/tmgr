json.array!(@project_statuses) do |project_status|
  json.extract! project_status, :id, :key, :name
  json.url project_status_url(project_status, format: :json)
end
