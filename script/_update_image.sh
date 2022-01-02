#!/bin/sh

# スクリプトファイルのある場所に移動
cd `dirname $0`

ecr_host=$(./_get_ecr_host.sh)

# Dockerfile のあるディレクトリに移動
cd ..

echo "ECR の認証情報を Docker に追加"
aws ecr get-login-password | docker login --username AWS --password-stdin $ecr_host

echo "Docker イメージをビルド"
docker build -t deno_lambda_sample .

docker tag deno_lambda_sample:latest "$ecr_host/deno_lambda_sample:latest"

echo "Docker イメージを ECR にプッシュ"
docker push "$ecr_host/deno_lambda_sample:latest"