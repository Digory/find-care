require('pg')

class SqlRunner

  # def self.run(sql, values = [])
  #   begin
  #     db = PG.connect({dbname: 'care', host: 'localhost'})
  #     db.prepare("query", sql)
  #     result = db.exec_prepared("query", values)
  #   ensure
  #     db.close() if db != nil
  #   end
  #   return result
  # end

  def self.run(sql, values = [])
    begin
      db = PG.connect({dbname: 'ddaa7cf7uq3tqn', host: 'ec2-23-21-216-174.compute-1.amazonaws.com', port: 5432, user: 'vetghccbabvnpd', password: '98e7842dc3bc3c005360795492b171c1dc6c63924ac066fc897f5c32a94a990d'})
      db.prepare("query", sql)
      result = db.exec_prepared("query", values)
    ensure
      db.close() if db != nil
    end
    return result
  end

end
