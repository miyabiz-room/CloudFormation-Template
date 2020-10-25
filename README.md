# AWS CloudFormationでS3にSPA(React)を構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b s3-01 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの dev 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      ├── app (Reactアプリ)
      └── s3 (スタック)
          ├─ s3.yml (CFnテンプレート)
          └─ dev-parameters.json (dev 環境のパラメータ)
    ```

## AWS リソース構築内容
  1. s3スタック
      - s3バケット (akane-dev-s3-reacts)
      - バケットポリシー (s3:GetObject)


## 実行環境の準備
[AWS CloudFormationを動かすためのAWS CLIの設定](https://qiita.com/miyabiz/items/fed11796f0ea2b7608f4)を参考にしてください。

## Reactアプリ ビルド手順
1.  予め node.js yarn をインストールする。

2.  下記を実行してアプリをビルドする

    ```
    cd akane/app

    yarn install

    yarn build
    ```

## AWS リソース構築手順
1.  下記を実行してスタックを作成

    ```
    ./create_stacks.sh
    ```

2.  下記を実行してスタックを削除

    ```
    ./delete_stacks.sh
    ```