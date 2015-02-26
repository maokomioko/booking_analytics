module Graph
  class GraphController < ApplicationController
    def holder
      render json: { yes: 'no', no: 'yes' }
    end
  end
end