require "minitest/autorun"
require 'mysql'
require 'json'
require 'net/http'
require_relative 'SqlConnection'
require_relative 'DbConnection'
require_relative 'ManageData'
require_relative 'GitTrends'

describe SqlConnection do
  before do
    @con = SqlConnection.new
  end

  describe "When the user calls the function to connect, create db and use it." do
    it "Must indicate the use of that database." do
      @sv = @con.connect('db', 'root', 'example')

      @con.use_db('gitapidb')

	  	@rs = @sv.query('select database()')

	  	@rs.fetch_row[0].must_equal("gitapidb")
    end
  end
end

describe DbConnection do
  before do
    @con = DbConnection.new
  end

  describe "When the user calls the function to connect directly to 'gitapidb' db." do
    it "Must indicate the use of that database." do
      @sv = @con.connect('db', 'root', 'example', 'gitapidb')

      @rs = @sv.query('select database()')
	  	
	  	@rs.fetch_row[0].must_equal("gitapidb")
    end
  end
end


describe GitTrends do
  before do
    @g = GitTrends.new
  end

  describe "When the user calls the function to get via http the trending repos." do
    it "Must return a hash containing three main items." do
      @rs = @g.get_git_trends

      @rs.length.must_equal(3)
    end
  end

  describe "When the user calls the function to get repository info." do
    it "Must return a hash containing the infos. including the user login." do
      @rs = @g.repo_info('bennyguitar', 'CollapseClick')

      @rs["owner"]["login"].must_equal('bennyguitar')
    end
  end
end

describe ManageData do
  before do
    @md = ManageData.new
    @g = GitTrends.new
  end

  describe "When the user calls the function to convert the hash into an sql statement." do
    it "Must return a sql that matches the hash data." do
    # Change it to use a generic hash
	  h = {'items'=>{0=>{'name'=>{},'id'=>{},'description'=>{},'stargazers_count'=>{},'owner'=>{'login'=>{}}}}}
	  h['items'][0]['name'] = 'testenome'
	  h['items'][0]['id'] = '1'
	  h['items'][0]['description'] = 'testedesc'
	  h['items'][0]['stargazers_count'] = '2'
	  h['items'][0]['owner']['login'] = 'testelogin'

    sql = @md.hash_to_sql(h,0)

    sql.must_equal("INSERT INTO repositories (id, user, name, description, stars) VALUES ('1', 'testelogin', 'testenome', 'testedesc', '2');")
    end
  end

  describe "When the user calls the function convert a query result in a list." do
    it "Must return an array corresponding to the query." do
      @con = Mysql.new('db', 'root', 'example', 'gitapidb')

      rs = @con.query('SELECT * FROM repositories ORDER BY stars DESC;')

      arr = @md.query_to_list(rs)

      arr[0][0].must_equal("8493324")
    end
  end
end

