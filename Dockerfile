FROM denoland/deno:1.17.1 as builder
WORKDIR /root
COPY src .
RUN deno compile \
    --allow-env \
    --allow-net \
    --output handler \
    index.ts


FROM public.ecr.aws/lambda/provided:al2 as runtime
WORKDIR ${LAMBDA_TASK_ROOT}

# AWS Lambda 実行環境でファイル書込み可能な /tmp 配下を DENO_DIR に設定する
ENV DENO_DIR=/tmp/deno

# Cloud Watch ログに、カラー表示のための制御文字が出力されるのを防ぐ
ENV NO_COLOR=true

COPY --from=builder /root/handler .
ENTRYPOINT [ "./handler" ]
