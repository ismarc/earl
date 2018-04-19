class ShortenerController < ApplicationController
  def index
  end

  def unshorten
    @link = Link.find_by(link_id: params[:id])
    if @link 
      puts "link: " + @link
      redirect_to @link.link
    else
      puts "link not found"
      redirect_to "http://www.google.com"
    end
  end
end
