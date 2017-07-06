
## Getting Started

### Base de données PostgreSQL

```
# Se connecter à psql
postgres=# CREATE USER justone CREATEDB;
postgres=# ALTER USER justone WITH SUPERUSER;
postgres=# \q
# Revenir dans le folder projet
bundle exec rake db:create
psql justonetotal_dev -c 'CREATE EXTENSION pg_trgm;'
psql justonetotal_dev -c 'CREATE EXTENSION unaccent;'
bundle exec rake db:migrate
```

### Installation des dépendances

Installer [NVM](https://github.com/creationix/nvm) pour gérer sa version de Node : 
```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
```

(Dans le projet) Installer et utiliser la version courante de Node :
```
# Installe la version de node spécifiée dans le .nvmrc
nvm install
# Switche vers la version de node spécifiée dans le .nvmrc
nvm use
```

(Optionel mais **fortement recommandé**) [Installer AVN](https://github.com/wbyoung/avn) pour éviter d'avoir à lancer `nvm use` à chaque ouverture du projet.

Installer yarn, le package manager pour les dépendances front-end :
```
brew install yarn --ignore-dependencies
# Voir https://yarnpkg.com/lang/en/docs/install/
```

Installer les dépendances front : 
```
yarn install
```

### Démarrer le serveur local

```
foreman start
```

Le projet est accessible sur [http://localhost:5000](http://localhost:5000)

### Gestion des assets

Les images et le CSS sont gérées de manière classique par [l'asset pipeline de rails](http://guides.rubyonrails.org/asset_pipeline.html), et se retrouvent donc dans le folder `app/assets` de l'app.

Le javascript est géré par [Webpacker](https://github.com/rails/webpacker), et se situe dans le folder `app/javascript` de l'app.
Le javascript du projet est écrit en ES6, et transpilé par babel.

### Organigraphe
Pour générer l'organigraphe des relations entre utilisateurs, le projet people utilise [https://github.com/e-lam/People-organigraph](https://github.com/e-lam/People-organigraph)

### Remplir la table des domaines autorisés à créer un compte
Seed des domaines en particulier

```
rake db:seed:domains:total (seed les domaines de la filiale Total)
rake db:seed:domains:hutchinson (seed les domaines de la filiale Hutchinson)
rake db:seed:domains (seed les domaines de toutes les filiales)
```
**Remarque :** `rake db:seed` seedera toutes les données disponibles en fonction de l'environnement. En staging ou en production cette ligne de remplira la table des domaines autorisés.

### Docker

Il est possible de démarrer l'application dans 2 containers :
- web : container application sur le port 3009
- db : container base de donndée Postgresql 9.4 sur le port 5439

```
# Pour lancer l'app (web) et la base de données (db) dans 2 containers différents
docker-compose up --build
# Pour initialiser la base, dans un autre terminal
docker-compose run web rake db:drop db:create db:migrate
# Seed la base de données
docker-compose run web rake db:seed
```

#### Troubleshooting

Si l'application est utilisée aussi en local, il se peut qu'elle ne démarre pas dans le container Docker.

Penser à supprimer le fichier server.pid (le répertoire /tmp étant dans .dockerignore)

```
sudo rm tmp/pids/server.pid
```

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

Visualiser la liste complètes des templates [ici](localhost:5000/rails/mailers)

## API et OAuth

Pour tester l'acces à l'api depuis un client en rails console
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
