# -*- encoding: utf-8 -*-
require 'sqlite3'

module Konbu

  class Saver

    def newRespondDB(dbname)
      db = SQLite3::Database.new("./#{dbname}.db")
      sql = "
      CREATE TABLE responds (
        text response,
        text targets
      );
      "
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

    def readResponds(dbname)
      db = SQLite3::Database.new("./#{dbname}.db")
      return db.execute("select response, targets from responds")
    end

  end

end
