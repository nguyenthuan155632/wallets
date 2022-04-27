# frozen_string_literal: true

json.extract! network, :id, :network_name, :chain_id, :created_at, :updated_at
json.url network_url(network, format: :json)
