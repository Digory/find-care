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
      db = PG.connect({dbname: 'dc8j1cmc3ln804', host: 'ec2-107-22-192-11.compute-1.amazonaws.com', port: 5432, user: 'qwridlezrefnzv', password: '8079860a1924a9742dcf8403545940c549c8846d2e44eac34bbb7f48ec2f424c'})
      db.prepare("query", sql)
      result = db.exec_prepared("query", values)
    ensure
      db.close() if db != nil
    end
    return result
  end

end
