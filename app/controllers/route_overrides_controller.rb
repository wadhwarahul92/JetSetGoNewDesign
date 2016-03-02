class RouteOverridesController < ApplicationController

  def welcome_index
    render template: 'welcome/index'
  end

end