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
    result_link = LinksController.create_link(params)
    if result_link
      redirect_to result_link
    else
      render body: nil, :status => :bad_request
    end
  end

  # Generate a link for a supplied Link object
  def link_url(param)
    return "links/" + param["link_id"]
  end

  # Create a new shortened URL based on the supplied params
  def self.create_link(params)
    if !params[:link]["link"].start_with?("http")
      params[:link]["link"] = "http://" + params[:link]["link"]
    end
    # Validate that the supplied link exists/works
    if !validate_link(params[:link]["link"])
      return nil
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
    
    return @link
  end

  private
    # Generate the link id to use
    def self.generate_id
      # Characters to use for id
      charset = Array('A'..'Z') + Array('a'..'z')
      # Generate an 8 character string
      # Made up of random characters from charset
      id = Array.new(8) { charset.sample }.join
      return id
    end

    # Validate that the supplied link resolves, is reachable and is loadable
    def self.validate_link(link)
      # Any exception thrown indicates a bad url, otherwise the url is good
      begin
        open(link)
      rescue
        return false
      end
      return true
    end
end
