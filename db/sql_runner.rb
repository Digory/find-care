require('pg')

class SqlRunner

  def self.run(sql, values = [])
    begin
      db = PG.connect({dbname: 'care', host: 'localhost'})
      db.prepare("query", sql)
      result = db.exec_prepared("query", values)
    ensure
      db.close() if db != nil
    end
    return result
  end

  # def self.run(sql, values = [])
  #   begin
  #     db = PG.connect({dbname: 'dbeg0r2l0c1tq5', host: 'ec2-54-235-73-241.compute-1.amazonaws.com', port: 5432, user: 'qvosjfwhzvwosw', password: '0567686a4630e81bfc552437a5049c74ef4987e3161985039b602fb447de9b99'})
  #     db.prepare("query", sql)
  #     result = db.exec_prepared("query", values)
  #   ensure
  #     db.close() if db != nil
  #   end
  #   return result
  # end

end
