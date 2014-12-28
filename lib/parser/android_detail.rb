require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'
module Parser
	class AndroidDetail

		def parse_game
			result = {}
			data = []
			url = execute_curl
			page = Nokogiri::HTML(open(url))

			if !page.nil?
	      	result["total_download"] = page.css('div.stars-count').children.text.strip.delete "()" if page.css('div.stars-count')
	    	  release_date = page.css('div.document-subtitle').children.text.delete "-" if page.css('div.document-subtitle')
	    	  result["release_date"] = release_date.strip if release_date
	    	  image_url = []
	    	  page.css('img.screenshot').each do |t|
	    	  	image_url << t["src"]
	    	  end
          result["image_url"] = image_url
          result["total_rating"] = page.css('div.score').text if page.css('div.score')
          rating_container = []
          rating = []
          total_rating = []
          page.css('div.rating-bar-container').each do |t|
          	rating_container << t.text.split
          	total_rating << t.text.split[1].gsub(/,/, '').to_i
          end
          result["total_rating"] = total_rating.inject{|sum,x| sum + x }
          rating << Hash[rating_container]
          result["rating"] = rating
          review = []
          page.css('div.single-review').each do |t|
            row = {}
          	row["name"] = t.css('span.author-name').text.strip
          	row["g_plus_id"] = t.css('a')[0].attributes["href"].value.delete "/store/people/details?id="
          	row["review_title"] = t.css('span.review-title').text
          	row["review_body"] = t.css('div.review-body').text.strip
          	review << row
	    	  end
	    	  result["review"] = review
	    	data << result 
	    end
	    return data
		end

		def execute_curl
			return "https://play.google.com/store/apps/details?id=com.kiloo.subwaysurf"
		end

	end
end