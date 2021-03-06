# frozen_string_literal: true

# Setup CarrierWave to use Amazon S3. Add `gem "fog-aws" to your Gemfile.
if Rails.application.secrets.dig(:aws_access_key_id).present?
    require 'carrierwave/storage/fog'

    CarrierWave.configure do |config|
      config.storage = :fog
      config.fog_provider = 'fog/aws'                                             # required
      config.fog_credentials = {
        provider:              'AWS',                                             # required
        aws_access_key_id:     Rails.application.secrets.aws_access_key_id,     # required
        aws_secret_access_key: Rails.application.secrets.aws_secret_access_key, # required
        region:                Rails.application.secrets.aws_region,                                    # optional, defaults to 'us-east-1'
        host:                  Rails.application.secrets.aws_host,                                  # optional, defaults to nil
        endpoint:              "https://#{Rails.application.secrets.aws_host}"
      }
      config.fog_directory  = Rails.application.secrets.aws_bucket                                 # required
      config.fog_public     = true                                               # optional, defaults to true
      config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }    # optional, defaults to {}
      config.storage = :fog
      config.asset_host = "https://#{Rails.application.secrets.aws_host}"
    end
else
    # Default CarrierWave setup.
    #
    CarrierWave.configure do |config|
      config.permissions = 0o666
      config.directory_permissions = 0o777
      config.storage = :file
      config.enable_processing = !Rails.env.test?
      # This needs to be set for correct attachment file URLs in emails
      # DON'T FORGET to ALSO set this in `config/application.rb`
      # config.asset_host = "https://your.server.url"
    end
end
