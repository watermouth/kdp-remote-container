FROM gcr.io/kaggle-images/python:v86

# ライブラリの追加インストール
RUN pip install -U pip && \
    pip install fastprogress japanize-matplotlib

# 以下は non-root user でのコンテナ実行もしくはコンテナ接続するためのユーザの作成
# https://aka.ms/vscode-remote/containers/non-root.
# buildKit
# 
# *** Caution ***
# base image のどこかで VOLUME /home が実行されている。
# https://docs.docker.jp/engine/reference/builder.html#volume
# > Dockerfile 内からのボリューム変更: ボリュームを宣言した後に、そのボリューム内のデータを変更する処理があったとしても、そのような変更は無視され処理されません。
# buildKitを使わずにdocker build すると、このimageではVOLUME /home が実行されているため、追加するnon-root userのホームディレクトリが作成されない(-m オプションが付いていてもダメ).
# 
# コンテナ内でのusernameとして使われるが、ホスト側で使用したいユーザ名に合わせなくても良い。
# ホスト側のユーザのUID, GIDを指定しておけば、コンテナ内で作成したユーザのファイルは、ホストからはホスト側のユーザのファイルとして扱える。
ARG USERNAME=vscode1
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************
# これによりrootもnon-rootも接続時のユーザのumaskが0002になる。~/.bashrcには影響がないが。
# 但し、docker 'run'時にはどうやら実行されないため、entrypoint.shの実行時にも無効となっているように思われる。
# RUN echo "umask 0002" >> /etc/bash.bashrc

# umask 0002をentrypoint.shに追加して実行するため、こちらで置き換える。
# chmod +x entrypoint.sh したファイルを用意することに注意。
COPY --chown=root:root entrypoint.sh /entrypoint.sh 
# chmodはもうすぐ使えるらしいがまだ駄目。
# COPY --chown=root:root --chmod=770 entrypoint.sh /entrypoint.sh 

# [Optional] Set the default user. Omit if you want to keep the default as root.
# USER $USERNAME
