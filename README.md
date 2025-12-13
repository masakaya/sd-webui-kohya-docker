# Stable Diffusion WebUI + Kohya SS Docker Environment

Stable Diffusion WebUIとKohya SS（LoRAトレーニング）をDockerで簡単に実行できる環境です。

## 概要

このプロジェクトは以下のサービスを提供します：

- **Stable Diffusion WebUI**: 画像生成用のWebインターフェース
- **Kohya SS**: LoRAモデルのトレーニング用GUI

両サービスはDocker Composeで管理され、共有ディレクトリを通じてLoRAモデルを連携できます。

## 前提条件

- Ubuntu 24.04
- Nvidia GPU
- Docker & Docker Compose
- Nvidia Container Toolkit

### 環境構築

Nvidia GPU環境のセットアップについては、以下のガイドを参照してください：

**[Ubuntu 24.04 Nvidia Setup Guide](https://github.com/masakaya/Ubuntu24.04_nvidia_setup_guide)**

上記ガイドに従って、Docker、Nvidia ドライバー、Nvidia Container Toolkitをインストールしてください。

## セットアップ

1. リポジトリをクローン

```bash
git clone https://github.com/masakaya/sd-webui-kohya-docker.git
cd sd-webui-kohya-docker
```

2. 必要なディレクトリを作成

```bash
make setup
```

3. Stable Diffusion v1.5モデルをダウンロード

```bash
make download-model
```

このコマンドは約4GBのモデルファイル（v1-5-pruned-emaonly.safetensors）をダウンロードします。既にモデルが存在する場合はスキップされます。

4. サービスを起動

```bash
make up
```

初回起動時は、Dockerイメージのダウンロードに時間がかかります。

## 使用方法

### サービスへのアクセス

- **Stable Diffusion WebUI**: http://localhost:7860
- **Kohya SS**: http://localhost:7861

### Makeコマンド

| コマンド | 説明 |
|---------|------|
| `make setup` | 必要なディレクトリを作成（Kohya SSリポジトリのクローンを含む） |
| `make setup-kohya` | Kohya SSリポジトリをクローン |
| `make build` | Kohya SS用のDockerイメージをビルド |
| `make download-model` | Stable Diffusion v1.5モデルを自動ダウンロード |
| `make up` | サービスをバックグラウンドで起動 |
| `make down` | サービスを停止 |
| `make logs` | 全サービスのログを表示 |
| `make logs-webui` | WebUIのログのみ表示 |
| `make logs-kohya` | Kohyaのログのみ表示 |
| `make clean` | サービスとボリュームを削除し、ディレクトリをクリーンアップ |
| `make clean-images` | Dockerイメージも含めて完全にクリーンアップ |

## ディレクトリ構造

```
.
├── compose.yml          # Docker Compose設定
├── Makefile            # 管理用Makeファイル
├── webui/              # Stable Diffusion WebUI用ディレクトリ
│   ├── models/         # モデルファイル
│   │   ├── Stable-diffusion/  # チェックポイントモデル
│   │   └── Lora/       # LoRAモデル（共有）
│   └── outputs/        # 生成画像
├── kohya/              # Kohya SS用ディレクトリ
│   ├── dataset/        # データセット用ディレクトリ
│   │   └── images/     # トレーニング画像（コンテナ内: /app/data）
│   │       └── [繰り返し数]_[識別名]/  # 例: 5_sks, 10_character
│   └── outputs/        # トレーニング結果
└── lora/               # LoRAモデル（共有）
```

### トレーニングデータの配置

Kohya SSでLoRAトレーニングを行う場合、画像は以下のディレクトリに配置します：

```
kohya/dataset/images/[繰り返し数]_[識別名]/
```

例：
- `kohya/dataset/images/5_sks/` - 5回繰り返し、識別名 "sks"
- `kohya/dataset/images/10_character/` - 10回繰り返し、識別名 "character"

各画像には対応するキャプションファイル（.txt）を用意するか、Kohya SSのBLIP機能で自動生成できます。

## モデルの配置

### Stable Diffusionモデル

#### 自動ダウンロード（推奨）

以下のコマンドでStable Diffusion v1.5モデルを自動的にダウンロードできます：

```bash
make download-model
```

#### 手動配置

他のモデルを使用したい場合は、以下のディレクトリに手動で配置してください：

```
webui/models/Stable-diffusion/
```

### LoRAモデル

Kohya SSで作成したLoRAモデルは自動的に `lora/` ディレクトリに保存され、WebUIから利用できます。

## トラブルシューティング

### GPUが認識されない場合

Nvidia Container Toolkitが正しくインストールされているか確認してください：

```bash
docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
```

### ポートが使用中の場合

`compose.yml` のポート設定を変更してください：

```yaml
ports:
  - "7860:7860"  # 別のポート番号に変更
```

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。

各サービスは独自のライセンスに従います：
- Stable Diffusion WebUI: [AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
- Kohya SS: [bmaltais/kohya_ss](https://github.com/bmaltais/kohya_ss)
