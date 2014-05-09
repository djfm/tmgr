json.array!(@languages) do |language|
  json.extract! language, :id, :locale, :name
  json.url language_url(language, format: :json)
end
