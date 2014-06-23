# -*- encoding: utf-8 -*-
require 'sqlite3'

module Konbu

  class Saver

    def new_respond_db(dbname)
      db = SQLite3::Database.new("./#{dbname}.db")
      sql = '
      CREATE TABLE responds (
        response text,
        targets text
      );
      CREATE TABLE info (
        name text,
        nameJP text
      );
      '
      db.execute_batch(sql)
    end

    def insert_responds(dbname, responds)
      db = SQLite3::Database.new("./#{dbname}.db")
      responds.each do |respond|
        sql = "insert into responds values('#{respond[0]}', '#{respond[1].join(',')}')"
        db.execute(sql)
      end
    end

    def insert_names(dbname, *name)
      names = name
      db = SQLite3::Database.new("./#{dbname}.db")
      sql = "insert into info values('#{names[0]}', '#{names[1]}')"
      db.execute(sql)
    end

    def read_responds(dbname)
      db = SQLite3::Database.new("./#{dbname}.db")
      (db.execute('select response, targets from responds')).map do |res|
        res = [res[0], res[1].split(',')]
      end
    end

  end

end
