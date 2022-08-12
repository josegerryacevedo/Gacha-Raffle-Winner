class Users::InvitePeopleController < ApplicationController
  require "rqrcode"
  before_action :url
  before_action :generate_qrcode

  def url
    if current_user
    @url="#{request.base_url}/users/sign_up?promoter=#{current_user&.email}"
    else
      @url="#{request.base_url}/users/sign_up"
    end
  end

  def generate_qrcode
    qrcode = RQRCode::QRCode.new(@url)
    @svg = qrcode.as_svg(
      color: "FFF",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
      fill: "ffffff00"
    )
  end
end