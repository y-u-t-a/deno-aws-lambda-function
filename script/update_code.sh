#!/bin/sh

# スクリプトファイルのある場所に移動
cd `dirname $0`

# AWS CLI のページャを無効化する
export AWS_PAGER=""

# イメージをプッシュ
./_update_image.sh

echo "最新のイメージを反映するために Lambda Function を更新"
ecr_host=$(./_get_ecr_host.sh)

aws lambda update-function-code \
  --function-name deno_lambda_sample_function \
  --image-uri "$ecr_host/deno_lambda_sample:latest"
