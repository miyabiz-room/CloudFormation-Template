# AWS CloudFormationでLambda Layerを使用したSlack通知定期実行Lambdaを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b lambda-01 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの dev 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      ├── lambda (スタック)
      │     ├── code
      │     │     └── getEC2InfoToSlack.py (S3アーティファクトソース)
      │     ├── code-lambda-getEC2InfoToSlack.zip (S3アーティファクト)
      │     ├── delete_artifact.dev.sh (S3アーティファクト削除シェル)
      │     ├── dev-parameters.json (dev 環境のパラメータ)
      │     ├── lambda.yml (CFnテンプレート)
      │     ├── mkzip.sh (S3アーティファクト作成シェル)
      │     └── upload_artifact.dev.sh (S3アーティファクトアップロードシェル)
      ├── lambda-layer (スタック)
      │   ├── all-parameters.json (all 環境のパラメータ)
      │   ├── code
      │   │   └── python
      │   │       ├── requirements.txt
      │   │       └── setSlackWebHook.py (S3アーティファクトソース)
      │   ├── code-lambda-setSlackWebHook.zip (S3アーティファクト)
      │   ├── delete_artifact.all.sh (S3アーティファクト削除シェル)
      │   ├── lambda-layer.yml (CFnテンプレート)
      │   ├── mkzip.sh (S3アーティファクト作成シェル)
      │   └── upload_artifact.all.sh (S3アーティファクトアップロードシェル)
      └─ s3 (スタック)
          ├─ s3.yml (CFnテンプレート)
          └─ all-parameters.json (all 環境のパラメータ)
    ```

## AWS リソース構築内容
  1. lambdaスタック
      - Lambdaロール
      - Lambda
      - Eventsルール
      - LambdaPermission
  2. lambda-layerスタック
      - Lambda-layer
  3. s3スタック
      - s3バケット (akane-all-s3-artifacts)
      - バケットポリシー (s3:GetObject)


## 実行環境の準備
[AWS CloudFormationを動かすためのAWS CLIの設定](https://qiita.com/miyabiz/items/fed11796f0ea2b7608f4)を参考にしてください。

## AWS リソース構築準備
1.  ```akane/lambda/dev-parameters.json``` の ```SlackWebHookUrl```にSlack Incoming WebhookのURLを記述する。

    ※ [incoming-webhook](https://slack.com/services/new/incoming-webhook)にて作成する

2.  ```akane/lambda/dev-parameters.json``` の ```SlackChannel```にSlack通知のチェンネル名を記述する。

    ```
    #test_slack
    ```

## AWS リソース構築手順
1.  下記を実行してスタックを作成

    ```
    ./create_stacks.sh
    ```

2.  下記を実行してLambdaの動作を確認

    ```
    ./test_lambda.sh
    ```

3.  下記を実行してスタックを削除

    ```
    ./delete_stacks.sh
    ```