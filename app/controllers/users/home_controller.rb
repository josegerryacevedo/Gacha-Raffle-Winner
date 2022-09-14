class Users::HomeController < ApplicationController
  def index
    @winners = Winner.published.limit(5)
  end
end
