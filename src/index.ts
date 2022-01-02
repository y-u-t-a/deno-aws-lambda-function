import { getContext, postResponce } from './lambdaRuntimeApiClient.ts'
import { handler } from './handler.ts'

const runTimeApiEndpoint = Deno.env.get("AWS_LAMBDA_RUNTIME_API")

if (runTimeApiEndpoint) {
  // AWS_LAMBDA_RUNTIME_API が設定されている場合は Lambda Runtime API を呼び出す
  const [requestId, payload] = await getContext(runTimeApiEndpoint)
  const response = handler(payload)
  await postResponce(runTimeApiEndpoint, requestId, response)
} else {
  // deno run でも実行できるようにするための実装
  const response = handler({})
  console.log(response)
}
