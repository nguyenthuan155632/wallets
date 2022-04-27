class AddNumberOfTokensToToken < ActiveRecord::Migration[6.1]
  def change
    add_column :tokens, :number_of_tokens, :string, default: ''

    RefreshDailyJob.perform_now
  end
end
