// deno-lint-ignore no-explicit-any
export function handler(payload?: any): BodyInit {
  console.log(payload)
  return JSON.stringify({
    status: 200
  })
}

