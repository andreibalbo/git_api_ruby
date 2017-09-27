require 'sinatra'
require 'erb'
require 'mysql'
require 'net/http'
require 'uri'
require 'sinatra/reloader'
require 'json'

#classes
require_relative 'SqlConnection'
require_relative 'DbConnection'
require_relative 'GitTrends'
require_relative 'ManageData'


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


	sql = SqlConnection.new
	sql.connect('db', 'root', 'example')
	sql.create_db('gitapidb')
	sql.use_db('gitapidb')

	"database criada com sucesso"
end

get '/ctable' do  

	con = DbConnection.new
	con.connect('db', 'root', 'example', 'gitapidb')
	con.query('CREATE TABLE repositories (id int,user varchar(50),name varchar(100),description varchar(500),stars int)')
	#con = Mysql.new('db', 'root', 'example', 'gitapidb') 
	#puts con.get_server_info
	#rs = con.query('CREATE TABLE repositories (id int,user varchar(50),name varchar(100),description varchar(500),stars int)')  
	"tabela criada com sucesso"

end


get '/get_trend' do  
	
	msg= ""

	con = DbConnection.new
	con.connect('db', 'root', 'example', 'gitapidb')
	con.query('delete from repositories where 1')

	get = GitTrends.new
	my_hash = get.get_git_trends
	num_items = my_hash["items"].count

	i = 0

	while i < num_items do
		md = ManageData.new
	 	sql = md.hash_to_sql(my_hash,i)
    	rs = con.query(sql)
    	msg += "#{sql} <br>"
    	i= i+1
	end

	return msg

end

get '/list_trend' do  

	con = DbConnection.new
	con.connect('db', 'root', 'example', 'gitapidb')
	rs = con.query('select * from repositories order by stars desc;')
	
	md = ManageData.new
	arr = md.query_to_list(rs)

	erb :list_trend, :locals => {:arr => arr}


end



get '/get_details/:id' do  
	
	id = params[:id]

	con = DbConnection.new
	con.connect('db', 'root', 'example', 'gitapidb')
	rs = con.query("SELECT user, name FROM repositories WHERE id=#{id}")	
	res = rs.fetch_row
	user = res[0]
	nome = res[1]

	get = GitTrends.new
	my_hash = get.repo_info(user,nome)

	md = ManageData.new

	hash2 = md.hash_to_details(my_hash)
	erb :get_details, :locals => {:hash2 => hash2}


end