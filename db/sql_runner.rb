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
  #     db = PG.connect({dbname: 'da3bj8fahflmk7', host: 'ec2-23-21-216-174.compute-1.amazonaws.com', port: '5432', user: 'btrsoozcfzwvxb', password: 'ffc52f39f05fc907d24cf4ca114811236d02f4878dfe2f54a2f50c2e39a2db6f'})
  #     db.prepare("query", sql)
  #     result = db.exec_prepared("query", values)
  #   ensure
  #     db.close() if db != nil
  #   end
  #   return result
  # end

end
