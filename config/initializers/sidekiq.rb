Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://lsa-avm-staging.miserver.it.umich.edu:7372/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://lsa-avm-staging.miserver.it.umich.edu:7372/0' }
end