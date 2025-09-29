class HomeController < ApplicationController
  allow_unauthenticated_access only: [:index]
  layout "public", only: [:index]
  layout "dashboard", only: [:dashboard]
  
  def index
    # Show public marketing page for all users (authenticated and unauthenticated)
  end
  
  def dashboard
    # Authenticated dashboard - requires authentication
  end
end
