require 'spec_helper'

module Graph
  describe GraphController, type: :controller do
    routes { Graph::Engine.routes }

    describe 'GET holder' do
      it 'returns success' do
        get :holder
        expect(response).to be_success
      end
    end
  end
end