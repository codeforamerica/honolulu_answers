AppConfig = YAML.load(ERB.new(File.read(Rails.root.join("config", "config.yml"))).result)[Rails.env]
AppConfig.symbolize_keys!
