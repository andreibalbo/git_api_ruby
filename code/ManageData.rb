class ManageData
	def hash_to_sql(h,i)
		id = h["items"][i]["id"]
		user = h["items"][i]["owner"]["login"];
		user.gsub("'"," ")
	   	nome = h["items"][i]["name"];
	   	nome.gsub("'"," ")
	   	desc = h["items"][i]["description"];
	   	if !desc.nil?
	   		desc = desc.to_s.gsub("'"," ")
    	end
    	stars = h["items"][i]["stargazers_count"];
    	sql = "insert into repositories (id,user,name,description,stars) values ('#{id}','#{user}','#{nome}','#{desc}','#{stars}');"
    		return sql
	end

	def query_to_list(query)
		i=0
		arr = Array.new(query.num_rows){Array.new(5)}
		while i < query.num_rows do
			row = query.fetch_row
			arr[i][0] = row[0]
			arr[i][1] = row[1]
			arr[i][2] = row[2]
			arr[i][3] = row[3]
			arr[i][4] = row[4]
			i=i+1
		end
		return arr
	end

	def hash_to_details(h)
		hash2 = {}
		#user
		hash2['user'] = h["owner"]["login"];
		hash2['user_id']= h["owner"]["id"];
		hash2['avatar_url'] = h["owner"]["avatar_url"];
		hash2['user_url'] = h["owner"]["html_url"];

		#repo
		hash2['id'] = h["id"];
		hash2['name'] = h["name"];
		hash2['description'] = h["description"];
		hash2['stars'] = h["stargazers_count"];
		hash2['repo_url'] = h["html_url"];
		hash2['created'] = h["created_at"];
		hash2['updated'] = h["updated_at"];
		hash2['pushed'] = h["pushed_at"];
		hash2['watchers'] = h["watchers_count"];
		hash2['language'] = h["language"];
		hash2['homepage'] = h["homepage"];
		hash2['size'] = h["size"];
		hash2['subscribers'] = h["subscribers_count"];
	
		return hash2
	end

end