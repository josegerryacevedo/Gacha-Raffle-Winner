class Users::InvitePeopleController < ApplicationController
  require "rqrcode"
  before_action :url
  before_action :generate_qrcode

  def url
    @url="#{request.base_url}/users/sign_up?promoter=#{current_user&.email}"
  end

  def generate_qrcode
    qrcode = RQRCode::QRCode.new(@url)
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true,
      fill: "00FFFF"
    )
  end
end