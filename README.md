# AWS CloudFormationでCloudFormationエンドポイントを使用したEC2インスタンスを構築しよう
みやびの部屋の提供する[AWS Cloud Formationテンプレート](https://github.com/miyabiz-room/CloudFormation-Template/tree/main)です。

1.  git cloneコマンド

    ```
    git clone -b vpc-endpoint-02 https://github.com/miyabiz-room/CloudFormation-Template.git
    ```

2.  環境

    akane-cfn というシステムの all 環境を想定しています。
    同じ構成で違う環境を作成する場合は、{環境名}-parameters.jsonを別途作成します。

    ```
    akane-cfn (システム)
      ├─ network (スタック)
      |   ├─ network.yml (CFnテンプレート)
      |   └─ all-parameters.json (all 環境のパラメータ)
      ├─ instance-cfn (スタック)
      |   ├─ instance-cfn.yml (CFnテンプレート)
      |   └─ all-parameters.json (all 環境のパラメータ)
      └─ endpoint-cfn (スタック)
          ├─ endpoint-cfn.yml (CFnテンプレート)
          └─ all-parameters.json (all 環境のパラメータ)
    ```

## AWS リソース構築内容
  1. networkスタック
      - VPC (10.0.0.0/16)
      - Publicサブネット (10.0.1.0/24)
      - インターネットゲートウェイ
      - Publicルートテーブル 
      - Elastic IP (NATゲートウェイ用)
 
  2. instance-cfnスタック
      - セキュリティグループ (インスタンス)
      - IAMロール (AdministratorAccess)
      - インスタンスプロファイル
      - EC2インスタンス (Amazon Linux 2)

  2. endpoint-cfnスタック
      - セキュリティグループ (エンドポイント:アウトバウンドにインスタンスのセキュリティグループを指定)
      - セキュリティグループのアウトバウンド (インスタンス:アウトバウンドにエンドポイントのセキュリティグループを指定)
      - CloudFormationエンドポイント (Interface)

## 実行環境の準備
[AWS CloudFormationを動かすためのAWS CLIの設定](https://qiita.com/miyabiz/items/fed11796f0ea2b7608f4)を参考にしてください。

## AWS リソース構築手順
1.  事前にEC2のキーペアを作成し、```akane-cfn/instance-cfn/all-parameters.json```の```KeyName```に記載します。

2.  下記を実行してスタックを作成

    ```
    ./create_stacks.sh
    ```

3.  下記を実行してスタックを削除

    ```
    ./delete_stacks.sh
    ```

## 関連情報
  - [[Qiita] AWS CloudFormationでCloudFormationエンドポイントを使用したEC2インスタンスを構築しよう](https://qiita.com/miyabiz/items/e71acb1e0fa34dd42ee3)