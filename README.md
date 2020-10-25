# AWS CloudFormationでWAFを設定したELBを構築しよう
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
      ├── network (スタック)
      │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   └── network.yml (CFnテンプレート)
      ├── sg (スタック)
      │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   └── sg.yml (CFnテンプレート)
      ├── elb (スタック)
      │   ├── dev-parameters.json (dev 環境のパラメータ)
      │   └── elb.yml (CFnテンプレート)
      └── waf (スタック)
          ├── dev-parameters.json (dev 環境のパラメータ)
          └── waf.yml (CFnテンプレート)
    ```

## AWS リソース構築内容
  1. networkスタック
    - VPC (10.0.0.0/16)
    - Publicサブネット1 (10.0.1.0/24)
    - Publicサブネット2 (10.0.2.0/24)
    - インターネットゲートウェイ
    - Publicルートテーブル
  2. sgスタック
    - セキュリティグループ(80ポートインバウンド許可)
  3. elbスタック
    - ELB
    - リスナー (80ポート)
    - ターゲットグループ (HealthCheckPathは/healthcheckとしています)
  4. wafスタック
    - ルールグループ(SQLインジェクション、XSS、ヘッダートークン認証[x-akane-id])
    - ウェブACL

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
  - [[Qiita] AWS CloudFormationでWAFを設定したELBを構築しよう](https://qiita.com/miyabiz/items/9b5da901601e947114ec)