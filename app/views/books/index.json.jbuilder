json.array!(@books) do |book|
  json.extract! book, :id, :book_id, :user_id, :available
  json.url book_url(book, format: :json)
end
