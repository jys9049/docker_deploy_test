import { NextResponse } from "next/server";

export async function GET() {
  const message = "Next.js health check OK at " + new Date().toISOString();
  console.log("[Health Check API] " + message); // 서버 로그에 찍히는지 확인!
  return NextResponse.json({ message });
}
