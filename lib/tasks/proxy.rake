namespace :proxy do
  # Use ngrok as an easy, free solution for simple self-hosting.
  # Assume ngrok domain has been kept in Rails credentials.
  # This value is used by bin/prod_proxy
  desc 'returns ngrok domain from credentials'
  task :serve do
    domain = Rails.application.credentials.ngrok.domain
    puts("ngrok http --url=#{domain} 3000")
  end
end