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
      db = PG.connect({dbname: 'd3gnvt5u1164sk', host: 'ec2-184-73-175-95.compute-1.amazonaws.com', port: 5432, user: 'ohfgterbkexmrk', password: '860124f6c0ab40cb6e6174337c4c94fbd9e36d26b36d6c3195937125c2805879'})
      db.prepare("query", sql)
      result = db.exec_prepared("query", values)
    ensure
      db.close() if db != nil
    end
    return result
  end

end
