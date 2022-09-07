class Users::HomeController < ApplicationController
  def index
    @winners = Winner.published
  end
end
