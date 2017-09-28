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
use_ssl = true

# First page just redirects to 'init' route.
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

# Adding parameters to display images and stuff.
get '/img/:file' do
  	send_file('/usr/src/app/img/' + params[:file], :disposition => 'inline')
end

get '/connect' do  
	# First connection to the mysql server attepting to create the database.
	sql = SqlConnection.new
	sv = sql.connect('db', 'root', 'example')

	sv.query("CREATE DATABASE 'gitapidb'")

	sql.use_db('gitapidb')

	"Database criada com sucesso."
end

get '/ctable' do  
	# Creating table to put repos info.
	con = DbConnection.new
	con.connect('db', 'root', 'example', 'gitapidb')

	con.query('CREATE TABLE repositories (id INT, user VARCHAR(50), name VARCHAR(100), description VARCHAR(500), stars INT)')

	"Tabela criada com sucesso."
end

get '/get_trend' do  
	msg= ""
	# Delete previous data from the table.
	con = DbConnection.new
	sv = con.connect('db', 'root', 'example', 'gitapidb')

	sv.query('delete from repositories where 1')

	# Http get to the github api.
	get = GitTrends.new
	my_hash = get.get_git_trends

	num_items = my_hash["items"].count

	# While to print and query the statements. (Change to .each or something)
	md = ManageData.new
	num_items.times do |i|
	 	sql = md.hash_to_sql(my_hash,i)

    	rs = sv.query(sql)

    	msg << "#{sql} <br>"
	end
	# Printing the message in the browser.
	return msg
end

# List saved repositories.
get '/list_trend' do  

	# Gets repositories basic information to display.
	con = DbConnection.new
	sv = con.connect('db', 'root', 'example', 'gitapidb')

	rs = sv.query('SELECT * FROM repositories ORDER BY stars DESC')
	
	# Convert the query using 'fetch_row' and store it in an array.
	md = ManageData.new
	arr = md.query_to_list(rs)

	# Add the array variable to 'locals'. Enabling it to be used in the '.erb' file.
	erb :list_trend, :locals => {:arr => arr}
end

# Get the details via HTTP GET and display it.
get '/get_details/:id' do  
	
	id = params[:id]

	# Get the username and reponame to HTTPGET the rest of the info.
	con = DbConnection.new
	sv = con.connect('db', 'root', 'example', 'gitapidb')

	rs = sv.query("SELECT user, name FROM repositories WHERE id=#{id}")

	res = rs.fetch_row
	user = res[0]
	nome = res[1]

	# Get info directly from the repository search.
	get = GitTrends.new
	my_hash = get.repo_info(user, nome)

	erb :get_details, :locals => {:my_hash => my_hash}
end