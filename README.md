# 目次

<details>
<summary>目次</summary>

<!--ts-->
* [目次](#目次)
* [概要](#概要)
   * [機能](#機能)
      * [面談候補日の作成](#面談候補日の作成)
         * [候補日のコピペ](#候補日のコピペ)
      * [面談日の確定](#面談日の確定)
   * [初期化手順について](#初期化手順について)
* [Google Cloud でのセットアップ](#google-cloud-でのセットアップ)
   * [プロジェクトの作成](#プロジェクトの作成)
   * [有効な API とサービス](#有効な-api-とサービス)
   * [OAuth 同意画面](#oauth-同意画面)
   * [認証情報](#認証情報)
      * [「OAuth 2.0 クライアント ID」の作成](#oauth-20-クライアント-idの作成)
         * [クライアント側で使う 認証情報](#クライアント側で使う-認証情報)
* [Rails 側のセットアップ](#rails-側のセットアップ)
   * [Bundler](#bundler)
   * [Node.js](#nodejs)
   * [データベース](#データベース)
   * [Rails Credentials](#rails-credentials)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: gouf, at: 2022年 7月18日 月曜日 00時41分29秒 JST -->

<!--te-->

</details>


# 概要

就職活動などで よく、メールのやり取りで「面談候補日をいくつか教えて下さい」「この日に確定しました」という流れがある

([Google Calendar](https://www.google.com/calendar) 上で) 面談先 A, B, C... ごとに、この「面談候補日」と「確定した面談日」を管理する

* 「この日は面談候補日だから、別の面談先には提示できない」
* 「面談候補日の中から面談日が確定したので、不要になった候補日群はかんたんに削除したい」
* 「面談日が確定して 候補日が無くなったので、別の面談候補日として使えるようになったのがわかった」

こういった作業を補助する

現バージョンではローカル環境で動くことを目的・ゴールとしている

## 機能

### 面談候補日の作成

面談候補日が作成できる

現在は固定で 3つの予定を立てられる

時間も固定で 14:00〜17:00 開始予定に設定している

Google Calendar 上でイベント作成するのと同様、「概要」「説明」欄を入力することができる


#### 候補日のコピペ

面談候補日を選ぶことで、メールの返信に使える「コピペ用文章」を生成する

当該文章欄をクリックするとコピペ用文章をコピーできる

eg.

```
1. n月m日 (月) 14:00〜17:00 に開始
2. n月m日 (月) 14:00〜17:00 に開始
3. n月m日 (月) 14:00〜17:00 に開始
```


### 面談日の確定

面談候補日から面談日を確定する

確定することで...

* (複数確保していた) 候補日群を削除する
* 確定した面談日として新たに、Google Calendar 上にイベントを作成する

候補日を作成したときに入力していた情報は引き継がれる


## 初期化手順について

アプリケーションとして利用するのに必要な初期化手順について説明する

大きく分けて次の流れになる

* Google Cloud でのセットアップ
* Rails 側でのセットアップ


# Google Cloud でのセットアップ

とりあえず、ローカルで動けばいいので、[コンソール ページ](https://console.cloud.google.com/) にアクセスし、次のように設定する

つぎの 4点を設定する

* 「プロジェクトの作成」
* 「有効な API とサービス」
* 「OAuth 同意画面」
* 「認証情報」

## プロジェクトの作成

ページ上部のプロジェクト名をクリックし、「新しいプロジェクト」をクリックする

適当な名前をつける

(参考: [【初心者向け】Google Cloud Platformに新規プロジェクトを作成する](https://www.teijitaisya.com/gcp-new-project/))


## 有効な API とサービス

本アプリケーションでは [Google Calendar API](https://developers.google.com/calendar/api) を利用するので、それを有効化する

「API とサービスの有効化」から次のように設定する

1. API ライブラリにアクセス
2. `calendar` で検索
3. 「Google Calendar API」をクリック
4. 「有効にする」をクリック


## OAuth 同意画面

[OAuth 同意画面](https://console.cloud.google.com/apis/credentials/consent) にアクセスし、同意画面を作成する

(URL は https://console.cloud.google.com/apis/credentials/consent?project=`[project name]` )


|       設定名        |             値            |
|---------------------|---------------------------|
| 公開ステータス      | テスト                    |
| ユーザの種類 (外部) | 内部                      |
| テストユーザ        | `[自分のメールアドレス]`  |


## 認証情報

[認証情報](https://console.cloud.google.com/apis/credentials) にアクセスし、認証情報を作成する

(URL は https://console.cloud.google.com/apis/credentials?project=`[project name]` )


### 「OAuth 2.0 クライアント ID」の作成

「認証情報を作成」から「OAuth クライアント ID」を選び、次のように設定する

| 設定名 | 値 |
|------------------------------|------------------------------------------------------------------------------|
| アプリケーションの種類       | ウェブ アプリケーション                                                      |
| 名前                         | `[任意の名前]`                                                               |
| 承認済みの JavaScript 生成元 | `http://localhost:3000`                                                      |
| 承認済みのリダイレクト URI   | `http://localhost:3000`, `http://localhost:3000/auth/google_oauth2/callback` |


#### クライアント側で使う 認証情報

クライアント ID の作成で、認証情報が得られる

「クライアント ID」, 「クライアント シークレット」の 2つは **あとで使う** ので、JSON ファイルのダウンロードや、テキストとして控えておく


# Rails 側のセットアップ

Rails 側では次の 4点を設定する

* Bundler
* Node.js
* データベース
* Rails Credentials

## Bundler

Gemfile に定義している gem のインストール

```bash
bundle install
```


## Node.js

Node.js パッケージのインストール

```bash
yarn install
```


## データベース

データベースの初期化

```bash
bundle exec rails db:create
bundle exec rails db:migrate
```


## Rails Credentials

機密情報の追加

```bash
rails credentials:edit
```

ここで Google Cloud 設定の認証情報を格納する (「クライアント ID」「クライアントシークレット」)

```yaml
google:
  client_id: 'xxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com'
  client_secret: 'XXXXXX-X-XXXXXXXXXXXXXXXXXXXXXXXXXX'
```
