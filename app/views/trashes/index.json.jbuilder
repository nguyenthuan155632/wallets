# frozen_string_literal: true

json.array! @trashes, partial: 'trashes/trash', as: :trash
