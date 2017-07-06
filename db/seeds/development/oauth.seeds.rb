class << self

  def insert_into(table_name, values)
    columns_str   = values.keys.map { |k| k.to_s }.join(", ")
    values_string = values.values.map { |v| "'#{v}'" }.join(", ")
    insert_sql    = "insert into #{table_name} (#{columns_str}) values (#{values_string})"
    ActiveRecord::Base.connection.execute insert_sql
  end

end

### Oauth Application

postman_oauth_application = {
    name:         "People App Test Local",
    uid:          "267a989b5a558ff0bc968106db3e4a77e184ffd2b9b5d2f4f5f20e3dc1d2cd75",
    secret:       "24a4ce2b6ced1c162038178816e4694d975ad0fb47c11a5fdb81db0023cfd471",
    redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
    created_at:   Time.current,
    updated_at:   Time.current
}
insert_into("oauth_applications", postman_oauth_application)

local_oauth_application = {
    name:         "People App Test Postman",
    uid:          "7bbb8ee2f5c2cad21d5311b47ce1c0e66952afeb745db331b6d7462f51ffa643",
    secret:       "7737d0bf2e9a1a969ecd0d7400be7e8973c31beb0ef978eb2c7e89568f20cc48",
    redirect_uri: "https://www.getpostman.com/oauth2/callback",
    created_at:   Time.current,
    updated_at:   Time.current
}
insert_into("oauth_applications", local_oauth_application)

