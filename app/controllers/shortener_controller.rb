require 'open-uri'

class ShortenerController < ApplicationController
  # Default entrypoint, displays the main page
  def index
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

  private
    # Generate the link id to use
    def generate_id
      # Characters to use for id
      charset = Array('A'..'Z') + Array('a'..'z')
      # Generate an 8 character string
      # Made up of random characters from charset
      id = Array.new(8) { charset.sample }.join
      return id
    end

    # Validate that the supplied link resolves, is reachable and is loadable
    def validate_link(link)
      begin
        open(link)
      rescue
        return false
      end
      return true
    end
end
