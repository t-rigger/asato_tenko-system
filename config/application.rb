require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TenkoSystem
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # I18nのロケールを日本語に設定する
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}").to_s]

    # タイムゾーンの設定
    config.time_zone = "Tokyo"
    # config.active_record.default_timezone = :local

    # デザインパターンの実装に使用するフォルダを読み込んでおく
    %w[forms policies decorators presenters queries services validators].each do |folder|
      config.autoload_paths.push(Rails.root.join("app", folder))
    end

    # field_with_errorsクラスを持つdivをエラー時に表示させない
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    # libディレクトリを自動読み込みする
    config.autoload_lib(ignore: %w[assets tasks])

    config.generators do |g|
      g.assets false
      g.helper false
      g.skip_routes true
      g.test_framework false
    end
  end
end
