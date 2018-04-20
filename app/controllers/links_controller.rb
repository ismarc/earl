require 'open-uri'

class LinksController < ApplicationController
  helper_method :link_url

  def display
    @link = Link.find_by(link_id: params[:id])
  end

  def index
    @links = Link.all
  end

  def new
  end

  # Create a new shortened url
  def create
    # Validate that the supplied link exists/works
    if !validate_link(params[:link]["link"])
      render :nothing => true, :status => :bad_request
      return
    end

    # Find any existing links for the provided URL so we don't generate duplicates
    prev_link = Link.find_by(link: params[:link]["link"])
    # Generate a new link id if there isn't a previous link
    link_id = if prev_link
      prev_link.link_id
    else
      generate_id()
    end

    params[:link]["link_id"] = link_id

    # Create a new link if necessary
    @link = if prev_link
      prev_link
    else
      Link.new(params.require(:link).permit(:link, :link_id))
    end

    # Save the state of the link prior to rendering
    @link.save()
    
    redirect_to @link
    #render plain: @link.link_id
  end

  # Generate a link for a supplied Link object
  def link_url(param)
    return "links/" + param["link_id"]
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
      # Any exception thrown indicates a bad url, otherwise the url is good
      begin
        open(link)
      rescue
        return false
      end
      return true
    end
end
