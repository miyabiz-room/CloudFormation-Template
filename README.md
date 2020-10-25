# AWS CloudFormationでS3のクロスリージョン相互レプリケーションを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b s3-02 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの dev 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      ├── s3 (スタック)
      │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   └── s3.yml (CFnテンプレート)
      └── s3-replication (スタック)
          ├── dev-parameters.json (dev 環境のパラメータ)
          └── s3-replication.yml -> ../s3/s3.yml (CFnテンプレートのシンボリックリンク)
    ```

## AWS リソース構築内容
  1. s3スタック
      - IAMロール (s3)
      - s3バケット (akane-dev-s3)

## 実行環境の準備
[AWS CloudFormationを動かすためのAWS CLIの設定](https://qiita.com/miyabiz/items/fed11796f0ea2b7608f4)を参考にしてください。

## AWS リソース構築手順
1.  下記を実行してスタックを作成

    ```
    ./create_stacks.sh
    ```

2.  下記を実行してスタックを削除

    ```
    ./delete_stacks.sh
    ```
