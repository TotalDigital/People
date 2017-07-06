# People
People lets you create your own professional network application.

## Getting Started


### Pre-requisites

 - Ruby 2.3.3
 - Rails 4.2.8
 - Postgresql

### Setup

1/ Clone this repo

```bash
git clone https://github.com/e-lam/People.git
```

2/ Install gems and dependencies
```bash
bundle install
```

3/ Create the database
```bash
rake db:create
```

4/ Run the migrations
```bash
rake db:migrate
```

5/ Run app Setup
```bash
rails g setup
```

6/ Launch locally
```bash
rails s
```

7/ Go to the app
Visit  http://localhost:3000 and log in with your admin email and password

## Email dans l'environnement local

Installer mailcatcher

```
gem install mailcatcher
```

Lancer mailcatcher à la racine du projet

```
mailcatcher -f > tmp/out.txt&
```

Visualiser les emails entrants [ici](http://localhost:1080/)

Visualiser la liste complètes des templates [ici](localhost:3000/rails/mailers)


### Filter your users
You can filter the users based on their email.

Add white-listed domains to domains list through admin backoffice :  http://localhost:3000/admin/domain

### Customizing

For basic personalization, replace following files by yours with right dimensions :

 - Logo: `assets/images/logo_header.png` (36 X 36 pixels)
 - Favicon: `assets/images/favicon.ico`  (32 X 32 pixels)
 - Background: `assets/images/bkg1.jpg`  (2500 X 1667 pixels)

### Deploying to Production

We recommend using Heroku.

1/ Create an account on Heroku
https://www.heroku.com/

2/ Install Heroku
https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction

3/ Deploy your code to Heroku

```bash
heroku create
git push heroku master
heroku run rake db:migrate
heroku open
```

## API & OAuth

To access the API from a web client or a rails console
```
app_id = "267a989b5a558ff0bc968106db3e4a77e184ffd2b9b5d2f4f5f20e3dc1d2cd75"
secret_id = "24a4ce2b6ced1c162038178816e4694d975ad0fb47c11a5fdb81db0023cfd471"
redirect_uri =  "urn:ietf:wg:oauth:2.0:oob"

client = OAuth2::Client.new(app_id, secret_id, site: 'http://localhost:3000')
auth_url = client.auth_code.authorize_url(redirect_uri: redirect_uri)
=> "http://localhost:3000/oauth/authorize?client_id=267a989b5a558ff0bc968106db3e4a77e184ffd2b9b5d2f4f5f20e3dc1d2cd75&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code"

code_value = "returned_authorization_code"
token = client.auth_code.get_token(code_value, redirect_uri: redirect_uri)

```
## Contributing

## Tests

## License
