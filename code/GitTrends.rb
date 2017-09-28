class GitTrends
	def get_git_trends
		url = 'https://api.github.com/search/repositories?q=created:>2000-01-01&sort=stars&order=desc'
		uri = URI(url)
		request = Net::HTTP::Get.new(uri.path)
		request['Content-Type'] = 'application/json'
		request["User-Agent"] = "Awesome-Octocat-App"
		response = Net::HTTP.get_response(uri)
		data = JSON.parse(response.body)
		return data
	end
	def repo_info(user,repo_name)
		url = "https://api.github.com/repos/#{user}/#{repo_name}"
		uri = URI(url)
		request = Net::HTTP::Get.new(uri.path)
		request['Content-Type'] = 'application/json'
		request["User-Agent"] = "Awesome-Octocat-App"
		response = Net::HTTP.get_response(uri)
		data = JSON.parse(response.body)
		return data
	end
end