## 使用技術
- バックエンド
  - Ruby 3.1
  - Rails 7.0.3<br>
- DB
  - MySQL 8.0.20<br>
- webサーバー
  - Nginx<br>
- アプリケーションサーバー
  - Puma<br>
- インフラ・開発環境等
  <!-- - AWS（VPC, ECS, ECR, RDS, S3, Route 53, ALB, ACM） -->
  - Docker/docker-compose(ローカル開発環境)
  <!-- - CircleCI(自動ビルド、自動テスト、自動デプロイ) -->
  - RSpec(テストフレームワーク)
  <!-- - rubocop(静的コード解析ツール)
  - brakeman(静的解析脆弱性診断) -->
  - Git, GitHub

## 機能一覧
- ユーザー登録・認証(sorcery)
  - 登録
    - 最初に登録するユーザー
    - 事務所を持たないユーザーを作成する
  - 更新
    - ユーザープロフィールの更新
- 事務所登録・管理
  - 事務所登録
  - ユーザー招待
    - ユーザーを追加するためのURLを発酵する
    - 事務所がない場合は招待出来ない
  - ユーザー追加
    - 招待URLを踏んでユーザー登録してない場合ユーザー登録画面へ
    - 招待URLを踏んでユーザー登録済なら事務所に所属

## ER図
以下URLの通り
https://lucid.app/lucidchart/67df0b81-a2d6-4245-9c98-4910db3cbd42/edit?invitationId=inv_3aacf30b-aff7-4cdb-b876-d206ebfe502f&page=0_0#

## インフラ構成図