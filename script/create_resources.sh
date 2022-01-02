#!/bin/sh

# スクリプトファイルのある場所に移動
cd `dirname $0`

# AWS CLI のページャを無効化する
export AWS_PAGER=""

echo "ECR リポジトリ deno_lambda_sample を作成"
aws ecr create-repository \
    --repository-name deno_lambda_sample

# イメージをプッシュ
./_update_image.sh

echo "IAM ロール deno_lambda_sample_role の作成"
# ロールの作成
role_arn=$( \
aws iam create-role \
  --role-name deno_lambda_sample_role \
  --assume-role-policy-document \
'{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}' \
  --query "Role.Arn" \
  --output text \
)
# ロールにポリシーをアタッチ
aws iam attach-role-policy \
  --role-name deno_lambda_sample_role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole


echo "Lambda Function deno_lambda_sample_function の作成"
ecr_host=$(./_get_ecr_host.sh)

# ロール作成（またはポリシーアタッチ）直後に Lambda Function を作成すると以下のエラーが発生するため sleep を挟む
# An error occurred (InvalidParameterValueException) when calling the CreateFunction operation: The role defined for the function cannot be assumed by Lambda.
sleep 8

aws lambda create-function \
    --function-name deno_lambda_sample_function \
    --role "$role_arn" \
    --package-type Image \
    --code ImageUri="$ecr_host/deno_lambda_sample:latest"
