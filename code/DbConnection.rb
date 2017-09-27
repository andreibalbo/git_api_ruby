class DbConnection
	def connect(sv,usr,pwd,db)
		@con = Mysql.new(sv,usr,pwd,db)
	end
	def query(string)
		return @con.query("#{string}")
	end
end