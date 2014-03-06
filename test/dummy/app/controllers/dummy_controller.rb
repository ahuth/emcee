class DummyController < ApplicationController
  def index
  end

  def assets
    # Send the compiled application.html as a string so that we can test asset
    # compilation.
    render json: Dummy::Application::assets.find_asset("application.html").source
  end
end
