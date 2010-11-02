class HomeController < ApplicationController
  def index
    if current_user
      redirect_to pending_shipments_path
    end
  end

end
