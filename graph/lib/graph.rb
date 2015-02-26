module Graph
  class Engine < ::Rails::Engine
    isolate_namespace Graph

    config.generators do |g|
      g.test_framework :rspec, fixture_replacement: :fabrication
      g.fixture_replacement :fabrication, dir: 'spec/fabricators'

      g.assets false
      g.view_specs false
      g.helper_specs false
    end
  end
end
