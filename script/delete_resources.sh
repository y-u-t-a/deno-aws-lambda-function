#!/bin/sh

# スクリプトファイルのある場所に移動
cd `dirname $0`

# AWS CLI のページャを無効化する
export AWS_PAGER=""

echo "ECR リポジトリ deno_lambda_sample を削除"
aws ecr delete-repository \
    --repository-name deno_lambda_sample \
    --force


echo "IAM ロール deno_lambda_sample_role の削除"
# ロール削除の前にポリシーをデタッチ
attached_policy_arn=$(
  aws iam list-attached-role-policies \
    --role-name deno_lambda_sample_role \
    --query 'AttachedPolicies[*].PolicyArn' \
    --output text \
)
for policy_arn in $attached_policy_arn
do
  aws iam detach-role-policy \
    --role-name deno_lambda_sample_role \
    --policy-arn $policy_arn
done
# ロールを削除
aws iam delete-role \
    --role-name deno_lambda_sample_role


echo "Lambda Function deno_lambda_sample_function の削除"
aws lambda delete-function \
    --function-name deno_lambda_sample_function


echo "deno_lambda_sample_function のロググループを削除"
aws logs delete-log-group \
    --log-group-name /aws/lambda/deno_lambda_sample_function
