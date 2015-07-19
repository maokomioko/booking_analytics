XMPAY_CONFIG = YAML.load_file(Rails.root.join('config', 'payment_gateway.yml'))[Rails.env]
