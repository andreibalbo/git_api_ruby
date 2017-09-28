class ManageData
  def hash_to_sql(h, i)
  	id = h["items"][i]["id"]
	user = h["items"][i]["owner"]["login"];
	user = user.gsub("'"," ")

	nome = h["items"][i]["name"];
	nome = nome.gsub("'"," ")

	# Those gsubs are to avoid problems with quotes.
	desc = h["items"][i]["description"];
	desc = desc.to_s.gsub("'", " ") unless desc.nil?

    stars = h["items"][i]["stargazers_count"];

    sql = "INSERT INTO repositories (id, user, name, description, stars) VALUES ('#{id}', '#{user}', '#{nome}', '#{desc}', '#{stars}');"
    return sql
  end

  def query_to_list(query)
	arr = []
	query.num_rows.times do
	  row = query.fetch_row
	  arr.push(row)
	end
	return arr
  end

end