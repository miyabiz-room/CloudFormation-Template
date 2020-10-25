# AWS CloudFormationでLamdaを排他制御するStep Functionsを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b step-funcs-01 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの dev 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      ├── apigw (スタック)
      │   ├── apigw.yml (CFnテンプレート)
      │   └── dev-parameters.json (dev 環境のパラメータ)
      ├── lambda (スタック)
      │   ├── createSQSMessage (スタック)
      │   │   ├── code
      │   │   │   └── createSQSMessage.py (S3アーティファクトソース)
      │   │   ├── createSQSMessage.yml (CFnテンプレート)
      │   │   ├── delete_artifact.dev.sh (S3アーティファクト削除シェル)
      │   │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   │   ├── mkzip.sh (S3アーティファクト作成シェル)
      │   │   └── upload_artifact.dev.sh (S3アーティファクトアップロードシェル)
      │   ├── getLock (スタック)
      │   │   ├── code
      │   │   │   └── getLock.py (S3アーティファクトソース)
      │   │   ├── delete_artifact.dev.sh (S3アーティファクト削除シェル)
      │   │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   │   ├── getLock.yml (CFnテンプレート)
      │   │   ├── mkzip.sh (S3アーティファクト作成シェル)
      │   │   └── upload_artifact.dev.sh (S3アーティファクトアップロードシェル)
      │   ├── setLock (スタック)
      │   │   ├── code
      │   │   │   └── setLock.py (S3アーティファクトソース)
      │   │   ├── delete_artifact.dev.sh (S3アーティファクト削除シェル)
      │   │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   │   ├── mkzip.sh (S3アーティファクト作成シェル)
      │   │   ├── setLock.yml (CFnテンプレート)
      │   │   └── upload_artifact.dev.sh (S3アーティファクトアップロードシェル)
      │   └── waitSecs (スタック)
      │       ├── code
      │       │   └── waitSecs.py (S3アーティファクトソース)
      │       ├── delete_artifact.dev.sh (S3アーティファクト削除シェル)
      │       ├── dev-parameters.json (dev 環境のパラメータ)
      │       ├── mkzip.sh (S3アーティファクト作成シェル)
      │       ├── upload_artifact.dev.sh (S3アーティファクトアップロードシェル)
      │       └── waitSecs.yml (CFnテンプレート)
      ├── role (スタック)
      │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   └── role.yml (CFnテンプレート)
      ├── s3 (スタック)
      │   ├── all-parameters.json (all) 環境のパラメータ)
      │   └── s3.yml (CFnテンプレート)
      ├── sqs (スタック)
      │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   └── sqs.yml (CFnテンプレート)
      └── step-funcs (スタック)
          ├── dev-parameters.json (dev 環境のパラメータ)
          └── step-funcs.yml (CFnテンプレート)
    ```

## AWS リソース構築内容
  1. apigwスタック
      - CloudWatch ログのロール
      - API Gateway
      - 使用量プラン
      - API キー
  2. lambdaスタック
      - Lambda (createSQSMessage, getLock, setLock, waitSecs)
  3. roleスタック
      - Lambdaロール
      - Step Functionsロール
      - API Gatewayロール
  4. s3スタック
      - s3バケット (akane-all-s3-artifacts)
      - バケットポリシー (s3:GetObject)
  5. sqsスタック
      - SQSキュー
      - アクセスポリシー
  6. step-funcsスタック
      - Step Functionsステートマシン

## 実行環境の準備
[AWS CloudFormationを動かすためのAWS CLIの設定](https://qiita.com/miyabiz/items/fed11796f0ea2b7608f4)を参考にしてください。

## AWS リソース構築手順
1.  下記を実行してスタックを作成

    ```
    ./create_stacks.sh
    ```

2.  下記を実行してLambdaの動作を確認

    ```
    ./test_lambda.sh
    ```

3.  下記を実行してStep Functionsの動作を確認

    ```
    ./test_step-funcs.sh
    ```

4.  下記を実行してAPI Gatewayの動作を確認

    ```
    ./test_apigw.sh <URL> <API_KEY>
    ```

5.  下記を実行してスタックを削除

    ```
    ./delete_stacks.sh
    ```