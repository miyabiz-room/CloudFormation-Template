# AWS CloudFormationでCloudFormationテンプレートのマクロを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b macro-01 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの all 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      └─ macro (スタック)
          ├─ macro.yml (CFnテンプレート)
          └─ all-parameters.json (all 環境のパラメータ)
    ```

## AWS リソース構築内容
  1. macroスタック
      - Lambda (マクロ)
      - Lambdaのアクセス許可 (CloudFormationが利用するため)
      - IAMロール (Lambda用)

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

## マクロの利用方法
1.  CloudFormationのテンプレート内で、組み込み関数```Transform```を利用して参照する

    ```
    Fn::Transform:
      - Name: convertString
        Parameters:
          InputString: 文字列
          Operation: Upper (パラメータ)
    ```

2.  利用できるパタメータ

    - Upper
    - Lower
    - Capitalize
    - Title
    - SwapCase

## 関連情報
  - [[Qiita] AWS CloudFormationでCloudFormationテンプレートのマクロを構築しよう](https://qiita.com/miyabiz/items/8246de1865b0a3308cda)