require "minitest/autorun"
require 'mysql'
require_relative 'SqlConnection'
require_relative 'DbConnection'
require_relative 'ManageData'
require_relative 'GitTrends'

describe SqlConnection do
  before do
    @con = SqlConnection.new
  end

  describe "When the user calls the function to connect, create db and use it" do
    it "Must indicate the use of that database" do
      @sv = @con.connect('db','root','example')
      @rs = @con.create_db('gitapidb')
      @con.use_db('gitapidb')
	  @rs = @sv.query('select database()')
	  @rs.fetch_row[0].must_equal("gitapidb")
    end
  end
end

