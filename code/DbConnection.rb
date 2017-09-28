class DbConnection
  def connect(sv,usr,pwd,db)
  	@con = Mysql.new(sv,usr,pwd,db)
  end
end