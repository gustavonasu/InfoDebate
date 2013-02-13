module ApplicationHelper
  
  def status_url(status)
    url = request.url
    url.sub!(/\?status=[^&]*/, "?")
    url.sub!(/&status=[^&]*/, "")
    url.sub!(/\?&/, "?")
    if request.url.include?("?")
      url += "&"
    else
      url += "?"
    end
    url += "status=#{status}"
  end
end
