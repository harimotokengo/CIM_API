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
  - 所属ユーザー一覧
  - 更新
    - admin_userのみ事務所情報を更新可能
- クライアント
  - 作成
    - 作成者にクライアントのadmin権限が付与される
    - タグ
      - 全角、半角スペース区切り
  - 一覧
    - 参加しているクライアントまたは参加している案件のクライアントが全件表示される  
    - 検索
      - スペース区切りで複数ワードで検索可能
      - 検索対象
        - 案件詳細、案件カテゴリー、案件タグ、クライアント名、クライアント名（かな）、
          クライアント旧姓、クライアント旧姓（かな）、クライアント特記事項、クライアント識別番号、
          クライアントメールアドレス、クライアント住所、クライアント電話番号、関係者名、
          関係者名（かな）、関係者旧姓、関係者旧姓（かな）、関係者メールアドレス、
          関係者住所、関係者電話番号
- クライアント参加
  - 管理事務所管理者・個人管理ユーザー
    - クライアントの更新、削除が出来る
    - クライアントの案件の追加、更新、閲覧が出来る
    - タスクの作成、更新、削除、閲覧が出来る
    - 参加事務所。ユーザーを案件アサイン登録、削除ができる
  - 参加事務所・ユーザー・管理事務所ユーザー
    - クライアントの閲覧が出来る
    - クライアントの案件の追加、閲覧が出来る
    - タスクの作成、閲覧が出来る
    - 自作タスクの更新、削除が出来る
    - 参加事務所。ユーザーを案件アサイン登録、削除ができる
- 案件参加
  - 管理事務所・ユーザー
    - 参加案件のクライアントの閲覧が出来る
    - 案件の更新、閲覧が出来る
    - タスクの作成、更新、閲覧が出来る
    - 参加事務所。ユーザーを案件アサイン登録、削除ができる
  - 参加事務所・ユーザー・管理事務所ユーザー
    - 参加案件のクライアントの閲覧が出来る
    - 参加案件の閲覧が出来る
    - 参加案件タスクの作成、閲覧が出来る
    - 自作タスクの更新、削除が出来る
    - 参加事務所。ユーザーを案件アサイン登録、削除ができる
- 案件担当
  
## ER図
以下URLの通り
https://lucid.app/lucidchart/67df0b81-a2d6-4245-9c98-4910db3cbd42/edit?invitationId=inv_3aacf30b-aff7-4cdb-b876-d206ebfe502f&page=0_0#

## インフラ構成図