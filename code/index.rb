require 'sinatra'
require 'erb'
require 'mysql'
require 'net/http'
require 'uri'
require 'sinatra/reloader'
require 'json'

set :bind, '0.0.0.0'

set :public_folder, File.dirname(__FILE__) + '/static'

use_ssl = true

get '/' do
  '<head>
    <title>App</title>
</head>
<body>

<meta http-equiv="refresh" content="0; url=/init" />


</body>'
end

get '/init' do
	erb :init
end

get '/img/:file' do
  send_file('/usr/src/app/img/'+params[:file], :disposition => 'inline')
end

get '/connect' do  
  
#my = Mysql.new(hostname, username, password, databasename)  
con = Mysql.new('db', 'root', 'example') 
puts con.get_server_info 
rs = con.query('CREATE DATABASE gitapidb;')  
rs = con.query('use gitapidb;')
"database criada com sucesso"
end

get '/ctable' do  
  
con = Mysql.new('db', 'root', 'example', 'gitapidb') 
puts con.get_server_info
rs = con.query('CREATE TABLE repositories (id int,user varchar(50),name varchar(100),description varchar(500),stars int)')  
"tabela criada com sucesso"

end


get '/get_trend' do  
	
	msg= ""

	con = Mysql.new('db', 'root', 'example', 'gitapidb') 
	rs = con.query('delete from repositories where 1;')  

	url = 'https://api.github.com/search/repositories?q=created:>2000-01-01&sort=stars&order=desc'
	
	uri = URI(url)
	
	request = Net::HTTP::Get.new(uri.path)


	request['Content-Type'] = 'application/json'
	request["User-Agent"] = "Awesome-Octocat-App"

	response = Net::HTTP.get_response(uri)
	#puts response.body
	my_hash = JSON.parse(response.body)

	#puts my_hash

	num_items = my_hash["items"].count
	i = 0

	while i < num_items do
		id = my_hash["items"][i]["id"]
		user = my_hash["items"][i]["owner"]["login"];
		user.gsub("'"," ")
    	nome = my_hash["items"][i]["name"];
    	nome.gsub("'"," ")
    	desc = my_hash["items"][i]["description"];
    	if !desc.nil?
    	desc = desc.to_s.gsub("'"," ")
    	end
    	stars = my_hash["items"][i]["stargazers_count"];

    	sql = "insert into repositories (id,user,name,description,stars) values ('#{id}','#{user}','#{nome}','#{desc}','#{stars}');"
    	#puts sql



    	rs = con.query(sql)

    	msg += "#{sql} <br>"
    	#deu certo so nao ta printando

    	i= i+1
	end

	return msg

end

get '/list_trend' do  


	con = Mysql.new('db', 'root', 'example', 'gitapidb')
	rs = con.query('select * from repositories order by stars desc;')
	
	i=0

	arr = Array.new(rs.num_rows){Array.new(5)}
	while i < rs.num_rows do
		row = rs.fetch_row
		arr[i][0] = row[0]
		arr[i][1] = row[1]
		arr[i][2] = row[2]
		arr[i][3] = row[3]
		arr[i][4] = row[4]
		i=i+1
	end
	erb :list_trend, :locals => {:arr => arr}


end



get '/get_details/:id' do  
	
	id = params[:id]

	msg= ""

	con = Mysql.new('db', 'root', 'example', 'gitapidb') 
	rs = con.query("SELECT user, name FROM repositories WHERE id=#{id}")

	res = rs.fetch_row

	user = res[0]
	nome = res[1]


	url = "https://api.github.com/repos/#{user}/#{nome}"
	
	uri = URI(url)
	
	request = Net::HTTP::Get.new(uri.path)


	request['Content-Type'] = 'application/json'
	request["User-Agent"] = "Awesome-Octocat-App"

	response = Net::HTTP.get_response(uri)
	#puts response.body
	my_hash = JSON.parse(response.body)

	#puts my_hash

	hash2 = {}
	#user
	hash2['user'] = my_hash["owner"]["login"];
	hash2['user_id']= my_hash["owner"]["id"];
	hash2['avatar_url'] = my_hash["owner"]["avatar_url"];
	hash2['user_url'] = my_hash["owner"]["html_url"];

	#repo
	hash2['id'] = my_hash["id"];
	hash2['name'] = my_hash["name"];
	hash2['description'] = my_hash["description"];
	hash2['stars'] = my_hash["stargazers_count"];
	hash2['repo_url'] = my_hash["html_url"];
	hash2['created'] = my_hash["created_at"];
	hash2['updated'] = my_hash["updated_at"];
	hash2['pushed'] = my_hash["pushed_at"];
	hash2['watchers'] = my_hash["watchers_count"];
	hash2['language'] = my_hash["language"];
	hash2['homepage'] = my_hash["homepage"];
	hash2['size'] = my_hash["size"];
	hash2['subscribers'] = my_hash["subscribers_count"];
	
	erb :get_details, :locals => {:hash2 => hash2}


end