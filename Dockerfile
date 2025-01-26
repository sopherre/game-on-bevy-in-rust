# Rust の公式イメージ（最新の安定版）を使用
FROM rust:latest

# 作業ディレクトリ設定
WORKDIR /app

# システムパッケージの更新および必要な依存関係のインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
  make \
  libudev-dev \
  pkg-config \
  libx11-dev \
  libxi-dev \
  libgl1-mesa-dev \
  libasound2-dev \
  libxrandr-dev \
  libxinerama-dev \
  libxcursor-dev \
  libwayland-dev \
  libxkbcommon-dev \
  && rm -rf /var/lib/apt/lists/*

# Rust のツールチェーンセットアップ
RUN rustup component add rustfmt clippy

# `cargo-watch` のインストール
RUN cargo install cargo-watch

# 依存関係を事前取得（キャッシュの最適化）
COPY Cargo.toml Cargo.lock /app/
RUN cargo build --release --locked || true

# ソースコードをコンテナにコピー（最後に実行してキャッシュを活用）
COPY . /app

# ビルド（エラーがあっても継続）
RUN cargo build --release || true

# デフォルトコマンド（開発用）
CMD ["sleep", "infinity"]