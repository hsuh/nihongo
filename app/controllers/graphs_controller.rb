class GraphsController < ApplicationController
  def social
    @network = File.read('public/clusters.json')
    @network = @network.gsub("\n","")

    respond_to do |format|
      format.json do
        render json: @network
      end
    end
  end
end
