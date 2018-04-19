require 'open-uri'

class ShortenerController < ApplicationController
  # Ignore security for post shorten calls, any call is good
  skip_before_action :verify_authenticity_token

  # Default entrypoint, displays the main page
  def index
  end

  # Shortens a URL that is provided in the request body
  def shorten
    # Read the link from the body
    request_link = request.body.read

    # Validate that the supplied link exists/works
    if !validate_link(request_link)
      render :nothing => true, :status => :bad_request
      return
    end

    # Find any existing links for the provided URL so we don't generate duplicates
    prev_link = Link.find_by(link: request_link)
    # Generate a new link id if there isn't a previous link
    link_id = if prev_link
      prev_link.link_id
    else
      generate_id()
    end

    # Generate the synthetic parameters for creating a new link
    p = ActionController::Parameters.new({
      link: {
        link: request_link,
        link_id: link_id
      }
    })

    # Create a new link if necessary
    link = if prev_link
      prev_link
    else
      Link.new(p.require(:link).permit(:link, :link_id))
    end

    # Save the state of the link prior to rendering
    link.save()
    # Render just the shortened URL back to the client
    render plain: "http://localhost:3000/" + link_id
  end

  # Given a link id, find the corresponding link and perform
  # a 302 redirect for it.
  def unshorten
    link = Link.find_by(link_id: params[:id])
    if link
      redirect_to link.link
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
