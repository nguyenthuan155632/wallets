namespace :scheduled_tasks do
  desc "Refresh Wallets"
  task refresh_wallets: :environment do
    # RefreshDailyJob.perform_later
    RefreshDailyJob.perform_now
  end
end
