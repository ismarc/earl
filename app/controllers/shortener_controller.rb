require 'open-uri'

class ShortenerController < ApplicationController
  # Ignore security for post shorten calls, any call is good
  skip_before_action :verify_authenticity_token

  # Shortens a URL that is provided in the request body
  def shorten
    request_url = params["link"]
    params = ActionController::Parameters.new({
      :link => {
        "link" => request_url
      }
    })

    result_link = LinksController.create_link(params)

    if result_link
      # Render just the shortened URL back to the client
      render plain: request.protocol + request.host_with_port + "/" + result_link.link_id
    else
      render body: nil, :status => :bad_request
    end
  end

  # Given a link id, find the corresponding link and perform
  # a 302 redirect for it.
  def unshorten
    link = Link.find_by(link_id: params[:id])
    if link && link.link
      redirect_to link.link
    else
      render plain: "Not Found", :status => :not_found
    end
  end
end
