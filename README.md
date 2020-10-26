# vscode Remote-Containers の使用例: 既存のDockerfileを用いたRemote-Containersの利用

## Test envirionment

- OS: Windows 10
- Docker  
  - docker desktop community
    - Engine: 19.03.12
- Virtual Envirionment(Distribution): WSL2(Ubuntu 20.04)
- Remote-Containers 0.145.1 in VS Code 1.50.1
- With Dockerfile
- Without Docker-Compose

## Key points

Docker, WSL2, VSCODE のそれぞれが関連しているため、注意が必要となっている。

- vscode Remote-Containers で Dockerfileを指定してコンテナを実行し、接続する手順
  - Remote-Containers の 各種コマンド
  - .devcontainer, devcontainer.json
- non-root userの追加とコンテナ実行または接続
  - DockerfileのVOLUME命令と BuildKit
- その他
  - dockerの build context

## 手順

### コンテナ内ユーザによる新規作成ファイルのpermission設定

rootユーザが作成したファイルもvscode1 groupのファイルとし、
グループオーナーもファイルの削除・実行が可能となるようにする。

1. ホスト側にデータ保存用のディレクトリを作成し、共有ディレクトリ設定をする。

``` bash
mkdir workspace
chmod 2770 workspace
```

2. コンテナ内のumaskを0002にする。

