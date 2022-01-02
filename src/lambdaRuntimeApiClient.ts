/**
 * Lambda の RequestId と Payload を返却する
 * https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/runtimes-api.html#runtimes-api-next
 * @returns [ RequestId, Payload ]
 */
// deno-lint-ignore no-explicit-any
export async function getContext(runTimeApiEndpoint: string): Promise<[string?, any?]> {
  const url = `http://${runTimeApiEndpoint}/2018-06-01/runtime/invocation/next`
  const response = await fetch(url, {
    method: "GET"
  })
  return [
    response.headers.get("Lambda-Runtime-Aws-Request-Id") || undefined,
    await response.json() || {}
  ]
}

/**
 * Lambda レスポンス API を呼び出す
 * https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/runtimes-api.html#runtimes-api-response
 * @param runTimeApiEndpoint 
 * @param requestId 
 * @param responceBody 
 */
export async function postResponce(
  runTimeApiEndpoint: string,
  requestId?: string,
  responceBody?: BodyInit
) {
  if (requestId === undefined) {
    return
  }
  const url = `http://${runTimeApiEndpoint}/2018-06-01/runtime/invocation/${requestId}/response`
  await fetch(url, {
    method: "POST",
    body: responceBody
  })
}