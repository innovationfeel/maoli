class HomeController < ApplicationController
  def index
    @projects = Project.order(created_at: :desc).all
  end
end
