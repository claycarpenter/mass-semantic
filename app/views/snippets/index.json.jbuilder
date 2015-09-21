json.array!(@snippets) do |snippet|
  json.extract! snippet, :id, :title, :code, :expl_md, :user_id
  json.url snippet_url(snippet, format: :json)
end
