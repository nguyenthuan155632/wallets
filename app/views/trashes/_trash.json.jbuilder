# frozen_string_literal: true

json.extract! trash, :id, :created_at, :updated_at
json.url trash_url(trash, format: :json)
