class ShortenerController < ApplicationController
  # Ignore security for post shorten calls, any call is good
  skip_before_action :verify_authenticity_token

  # Default entrypoint, displays the main page
  def index
  end

  # Shortens a URL that is provided in the request body
  def shorten
    # Find any existing links for the provided URL so we don't generate duplicates
    prev_link = Link.find_by(link: params[:link])
    # Generate a new link id if there isn't a previous link
    link_id = if prev_link
      prev_link.link_id
    else
      generate_id()
    end

    # Generate the synthetic parameters for creating a new link
    p = ActionController::Parameters.new({
      link: {
        link: params[:link],
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

  # Generate the link id to use
  def generate_id
    # Generate an 8 character string (0...8)
    # Made up of random uppper case letters
    id = (0...8).map { (65 + rand(26)).chr }.join
    return id
  end
end
