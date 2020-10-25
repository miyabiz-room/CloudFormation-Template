# AWS CloudFormationでECRリポジトリを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b waf-01 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの dev 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      └── repo (スタック)
          ├── dev-parameters.json (dev 環境のパラメータ)
          └── repo.yml (CFnテンプレート)
    ```

## AWS リソース構築内容
  1. ECRスタック
    - リポジトリ (タグのイミュータビリティ有効、イメージスキャンの設定有効)
    - ライフサイクルポリシールール (30イメージ以上は削除する)

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

## 関連情報
  - [[Qiita] AWS CloudFormationでECRリポジトリを構築しよう](https://qiita.com/miyabiz/items/ad292290151680ac14ef)