class GitTrends
	def get_git_trends
		url = 'https://api.github.com/search/repositories?q=created:>2000-01-01&sort=stars&order=desc'
		uri = URI(url)
		request = Net::HTTP::Get.new(uri.path)
		request['Content-Type'] = 'application/json'
		request["User-Agent"] = "Awesome-Octocat-App"
		response = Net::HTTP.get_response(uri)
		my_hash = JSON.parse(response.body)

		return my_hash
	end
	def repo_info(user,repo_name)




	end
end