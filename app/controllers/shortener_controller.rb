class ShortenerController < ApplicationController
  # Ignore security for post shorten calls, any call is good
  skip_before_action :verify_authenticity_token

  def index
  end

  def shorten
    prev_link = Link.find_by(link: params[:link])
    link_id = if prev_link
      prev_link.link_id
    else
      generate_id()
    end
    p = ActionController::Parameters.new({
      link: {
        link: params[:link],
        link_id: link_id
      }
    })

    link = if prev_link
      prev_link
    else
      Link.new(p.require(:link).permit(:link, :link_id))
    end
    link.save()
    render plain: "http://localhost:3000/" + link_id
  end

  def unshorten
    link = Link.find_by(link_id: params[:id])
    if link
      redirect_to link.link
    end
  end

  def generate_id
    # Generate an 8 character string (0...8)
    # Made up of random uppper case letters
    id = (0...8).map { (65 + rand(26)).chr }.join
    return id
  end

  private
    def link_attributes
      permitted = params.require :link
      puts "Permitted: " + permitted
      params.required(:link).permit(:link_id)#.required(:link_id)
    end
end
