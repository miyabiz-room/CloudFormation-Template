# AWS CloudFormationでVPCを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b vpc-01 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane というシステムの dev 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane (システム)
      └─ network (スタック)
          ├─ network.yml (CFnテンプレート)
          └─ dev-parameters.json (dev 環境のパラメータ)
    ```

## AWS リソース構築内容
  - VPC (10.0.0.0/16)

## AWS システム構成図
![vpc.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/682035/150a0925-0a29-84ce-00ae-83af0c5fed2c.png)

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
  - [[Qiita] AWS CloudFormationでVPCを構築しよう](https://qiita.com/miyabiz/items/e26702b6e20bfd2ecfd4)