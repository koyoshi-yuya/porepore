# README

## 開発用MySQL

Dockerが起動した状態で、MySQL 8.4 LTSの公式イメージ `mysql:8.4.11` を取得してDBを起動します。

```sh
docker compose pull db
docker compose up -d db
docker compose ps
```

接続先は `127.0.0.1:3306`、DB名は `porepore_development`、ユーザー名は
`porepore`、パスワードは `porepore_password` です。rootのパスワードは
`root_password` です。これらはローカル開発用の初期値です。
`MYSQL_PORT`、`MYSQL_DATABASE`、`MYSQL_USER`、`MYSQL_PASSWORD`、
`MYSQL_ROOT_PASSWORD` を環境変数または `.env` で指定して変更できます。
DB名・ユーザー・パスワードの初期化設定は、データボリュームが空のときのみ適用されます。

```sh
# コンテナ内から接続（パスワードの入力が必要）
docker compose exec db mysql -u porepore -p porepore_development

# 停止（データは名前付きボリュームに保持）
docker compose down
```

RailsのDB設定は現在SQLiteです。RailsからMySQLを利用するには、別途
`mysql2` gemの追加と `config/database.yml` の変更が必要です。

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
