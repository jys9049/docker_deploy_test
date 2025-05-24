import { NextResponse } from "next/server";

export async function GET() {
  const testkey = process.env.TEST_KEY;
  const message =
    "Next.js health check OK at " +
    new Date().toISOString() +
    "and Secret key check " +
    testkey;
  console.log("[Health Check API] " + message); // 서버 로그에 찍히는지 확인!
  return NextResponse.json({ message });
}
