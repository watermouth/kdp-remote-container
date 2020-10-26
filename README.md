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

``` bash
# 何らかの方法で作成する. ここではbase imageにあるentrypoint.shの中身をコピーしてbuild context上にファイルとして作成.
# vi entorypoint.sh
# 実行権限を付けておく
chmod +x entrypoint.sh
```

これはentrypoint.shを作成して、その中でumask 0002とする。
remote-containersではwslコマンドからdocker 'run'など実行しているので、docker run時にコンテナ内でumaskを有効化するには、
entrypoint.shの中でumaskしておく必要がある。
remote-containers: show log で docker 'run' を検索すると実行箇所が分かる。

