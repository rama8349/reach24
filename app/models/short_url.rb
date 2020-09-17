class ShortUrl < ApplicationRecord
	UNIQUE_ID_LENGTH =5
	validates :original_url, presence: true, on: :create
	validates :original_url, uniqueness: true, on: :create
	validates :original_url, format: URI::regexp(%w[http https])

	before_create :generate_short_url
	before_create :sanitize


	def generate_short_url
		url =([*('a'..'z'),*(1..9)]).sample(UNIQUE_ID_LENGTH).join
		old_url =ShortUrl.where(short_url: url).last
		if old_url.present?
			self.short_url = self.generate_short_url
		else
			self.short_url = url
		end
	end
	def new_url?
		find_duplicate.nil? 
	end
	def find_duplicate
		ShortUrl.find_by_sanitize_url(self.sanitize_url)
	end

	def sanitize
		if self.original_url.present?
			self.original_url.strip!
			self.sanitize_url= self.original_url.downcase.gsub(/(htpps?:\/\/)|(www\.)/ ,"")
			self.sanitize_url= "htpp://#{self.sanitize_url}"
		end
	end

end
