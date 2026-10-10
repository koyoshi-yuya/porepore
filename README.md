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

## Railsの起動

Docker上でRailsとMySQLをまとめて起動できます。Mac側へのRubyやMySQLクライアントのインストールは不要です。

```sh
docker compose up --build -d web
docker compose logs -f web
```

`http://localhost:3000` でアクセスできます。

```sh
docker compose exec web bin/rails console
docker compose exec web bin/rails test
docker compose down
```

### ホスト上でRailsを起動する場合

RailsもMySQLを使用します。macOSでは、mysql2 gemのビルド用クライアントを用意します。

```sh
brew install mysql-client@8.4
bundle config set --local build.mysql2 "--with-mysql-config=$(brew --prefix mysql-client@8.4)/bin/mysql_config"
bundle install
docker compose up -d db
bin/rails db:prepare
bin/rails server
```

開発用DBとは別に、初回起動時に `porepore_test` を作成し、アプリ用ユーザーに
テストDBの権限を付与します。既存ボリュームを使う場合は、次のコマンドを一度実行してください。

```sh
docker compose exec db bash /docker-entrypoint-initdb.d/init-test-db.sh
bin/rails test
```

