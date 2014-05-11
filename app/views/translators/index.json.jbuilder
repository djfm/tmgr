json.array!(@translators) do |translator|
  json.extract! translator, :id, :email, :firstname, :lastname
  json.url translator_url(translator, format: :json)
end
