# インストール

## Gem のインストール

```sh
bundle install
```

## `credentials.json` の設置

次の path に認証情報を記録した JSON ファイルを設置する

`lib/api/google_calendar/credentials.json`

当該ファイルは「[Ruby Quickstart  |  Calendar API  |  Google Developers](https://developers.google.com/calendar/quickstart/ruby)」から得られる

```json
{"installed":{"client_id":"000000000000-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com","project_id":"quickstart-0000000000000","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"xxxxxxxxxxxxxxxxxxxxxxxx","redirect_uris":["urn:ietf:wg:oauth:2.0:oob","http://localhost"]}}
```


### 認証の実行

```sh
bundle exec ruby main.rb
```

適当なスケジュールを作成し、Google Calendar API の認証処理を走らせる

指示に従い認証する


### `token.yaml` の生成

認証が終われば `token.yaml` が生成される

`lib/api/google_calendar/token.yaml`

```yaml
---
default: '{"client_id":"000000000000-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com","access_token":"xxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxx","refresh_token":"0/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx","scope":["https://www.googleapis.com/auth/calendar.events"],"expiration_time_millis":1613176786000}'
```

以降の認証は設定期限経過まで要求されない
