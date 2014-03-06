require 'active_record'
require 'activerecord-jdbcmysql-adapter'


DB_PASS = ENV["DB_PASS"]
DB_NAME = ENV["DB_NAME"]
DB_USER = ENV["DB_USER"]

if ENV["RACK_ENV"] == 'production'
  ActiveRecord::Base.establish_connection(
    :adapter=>  'mysql2',
    :host => "opener-olery.cqlc6ghud3pa.eu-west-1.rds.amazonaws.com",
    :username => "enouch",
    :password => DB_PASS,
    :database => "opener-olery",
  )
else
  ActiveRecord::Base.establish_connection(
    adapter:  'mysql2',
    host:     'localhost',
    username: 'root',
    password: DB_PASS || '',
    database: DB_NAME || 'opener_development'
  )
end

if ActiveRecord::Base.connection.execute("SHOW INDEX FROM output_scores").nil?
  ActiveRecord::Base.connection.execute("CREATE INDEX uuid_index ON output_scores(uuid);")
end
ActiveRecord::Base.connection.execute("CREATE TABLE IF NOT EXISTS output_scores (uuid varchar(40), raw_text longtext, bathroom double,breakfast double,cleanliness double,facilities double,internet double,location double,noise double,parking double,restaurant double,room double,sleeping_comfort double,staff double,swimming_pool double,value_for_money double, overall double);")
