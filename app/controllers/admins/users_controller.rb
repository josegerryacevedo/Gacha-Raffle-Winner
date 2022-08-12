class Admins::UsersController < AdminController
  def index
    @users = User.where(role: :client)
  end
end