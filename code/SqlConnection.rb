class SqlConnection
	def connect(sv,user,pwd)
		@con = Mysql.new(sv,user,pwd)
	end
	def create_db(n)
		return @con.query("CREATE DATABASE #{n}")
	end
	def use_db(n)
		return @con.query("use #{n}")
	end

end