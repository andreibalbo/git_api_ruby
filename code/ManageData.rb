class ManageData
  def hash_to_sql(h, i)
  	id = h["items"][i]["id"]
	user = h["items"][i]["owner"]["login"];
	user.gsub("'"," ")
	nome = h["items"][i]["name"];
	nome.gsub("'"," ")
	desc = h["items"][i]["description"];
	if !desc.nil?
	  desc = desc.to_s.gsub("'", " ")
    end
    stars = h["items"][i]["stargazers_count"];
    sql = "INSERT INTO repositories (id, user, name, description, stars) VALUES ('#{id}', '#{user}', '#{nome}', '#{desc}', '#{stars}');"
      return sql
  end

  def query_to_list(query)
    i = 0
	arr = Array.new(query.num_rows){Array.new(5)}
	while i < query.num_rows do
	  row = query.fetch_row
	  arr[i][0] = row[0]
	  arr[i][1] = row[1]
	  arr[i][2] = row[2]
	  arr[i][3] = row[3]
	  arr[i][4] = row[4]
	  i = i + 1
	end
	return arr
  end

end