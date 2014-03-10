class DummyController < ApplicationController
  def index
  end

  def assets
    # Render an asset as a json string so that we can test it.
    path = params[:file]
    compiled = Dummy::Application::assets.find_asset(path)

    if compiled.nil?
      render json: nil
    else
      # The source method here causes the asset pipeline to compile and
      # concatenate the asset.
      render json: compiled.source
    end
  end
end
