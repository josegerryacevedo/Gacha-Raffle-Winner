class AdminController < ApplicationController
  before_action :authenticate_admins_user!
end