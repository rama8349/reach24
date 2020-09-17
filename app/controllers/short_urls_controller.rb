class ShortUrlsController < ApplicationController
	before_action :find_url , only: [:show,:short]
	skip_before_action :verify_authenticity_token

	def index
		@short_urls =ShortUrl.all
	end
	def new
		@short_url =ShortUrl.new
	end

	def create
		@short_url =ShortUrl.new
		@short_url.original_url = params[:short_url][:original_url]
		@short_url.sanitize
		if @short_url.new_url?
			if @short_url.save
				redirect_to short_url_path(@short_url.id)
			else
				flash[:error]= 'check the error below'
				render :new
			end
		else
			flash[:error] = 'Short link for this URL is already exist'
			redirect_to short_url_path(@short_url.find_duplicate.short_url)
		end
	end

	def show	
		@short_url =ShortUrl.find_by_short_url(params[:id])
	end

	def short
		@short_url = ShortUrl.find_by_short_url(param[:short_url])
		host =request.host_with_port
		@original_url = @short_url.sanitize_url
		@short_url = @host + '/'+ @short_url.short_url
	end

	private
	def short_url_params
		params.require(:short_url).permit(:short_url)
	end

	def find_url
		@short_url =ShortUrl.find_by_short_url(params[:short_url])
	end

	# def 

end
