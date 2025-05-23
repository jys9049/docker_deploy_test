"use client";

export default function Page() {
  console.log(process.env.NEXT_PUBLIC_TEST_KEY ?? "no client test key");

  return <h1>안녕하세요! 메인 페이지입니다.</h1>;
}
