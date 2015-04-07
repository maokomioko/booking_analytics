require 'spec_helper'

module Graph
  describe HotelsController, type: :controller do
    routes { Graph::Engine.routes }

    describe 'GET index' do
      # it 'returns success' do
      #   get :index
      #   expect(response).to be_success
      # end
    end
  end
end
