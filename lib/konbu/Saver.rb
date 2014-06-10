# -*- encoding: utf-8 -*-
require 'sqlite3'

module Konbu

  class Saver

    def newRespondDB(dbname)
      db = SQLite3::Database.new("./#{dbname}.db")
      sql = "
      CREATE TABLE responds (
        response text,
        targets text
      );
      CREATE TABLE info (
        name text,
        nameJP text
      );
      "
      db.execute_batch(sql)
      db.close()
    end

    def insertResponds(dbname, responds)
      db = SQLite3::Database.new("./#{dbname}.db")
      responds.each do |respond|
        sql = "insert into respond values (?, ?)", respond[0], respond[1].join(",")
        db.execute(sql)
      end
      db.close()
    end

    def insertNames(dbnames, names)
      db = SQLite3::Database.new("./#{dbname}.db")
      sql = "insert into names values (?, ?)", names[0], names[1]
      db.execute(sql)
      db.close()
    end

    def readResponds(dbname)
      db = SQLite3::Database.new("./#{dbname}.db")
      return db.execute("select response, targets from responds")
    end

  end

end
