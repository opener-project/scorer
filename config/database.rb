require 'active_record'
require 'mysql2'


DB_PASS = ENV["DB_PASS"]
DB_NAME = ENV["DB_NAME"]
DB_USER = ENV["DB_USER"]

if ENV["RACK_ENV"] == 'production'
  client = Mysql2::Client.new(
    :host => "opener-olery.cqlc6ghud3pa.eu-west-1.rds.amazonaws.com",
    :username => "enouch",
    :password => DB_PASS,
    :database => "opener-olery",
  )

  client.query("CREATE TABLE IF NOT EXISTS output_scores (uuid varchar(40), raw_text text, bathroom double,breakfast double,cleanliness double,facilities double,internet double,location double,noise double,parking double,restaurant double,room double,sleeping_comfort double,staff double,swimming_pool double,value_for_money double, overall double);")
  client.query("CREATE INDEX uuid_index ON output_scores(uuid);") if client.query("SHOW INDEX FROM output_scores").nil?

  ActiveRecord::Base.establish_connection(
    adapter:  'mysql2',
    database: 'opener-olery',
    host:     'opener-olery.cqlc6ghud3pa.eu-west-1.rds.amazonaws.com',
    username: 'enouch',
    password: DB_PASS
  )
else
  client = Mysql2::Client.new(
    :host => "localhost",
    :username => DB_USER || "root",
    :password => DB_PASS || "",
    :database => DB_NAME || "opener_development"
  )

  client.query("CREATE TABLE IF NOT EXISTS output_scores (uuid varchar(40), raw_text text, bathroom double,breakfast double,cleanliness double,facilities double,internet double,location double,noise double,parking double,restaurant double,room double,sleeping_comfort double,staff double,swimming_pool double,value_for_money double, overall double);")
  client.query("CREATE INDEX uuid_index ON output_scores(uuid);") if client.query("SHOW INDEX FROM output_scores").nil?

  ActiveRecord::Base.establish_connection(
    adapter:  'mysql2',
    host:     'localhost',
    username: 'root',
    password: DB_PASS || '',
    database: DB_NAME || 'opener_development'
  )
end
