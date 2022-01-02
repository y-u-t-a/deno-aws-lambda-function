# Deno を AWS Lambda で動かす

AWS Lambda のコンテナランタイムをカスタマイズして Deno を動かす。


## AWS リソース作成

```bash
./script/create_resources.sh
```

## Lambda Function の更新

```bash
./script/update_code.sh
```

## AWS リソース削除

```bash
./script/delete_resources.sh
```
