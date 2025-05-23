export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  console.log(process.env.TEST_KEY || "no server test key");

  return (
    <html lang="ko">
      <body>
        <p>기본 레이아웃 시작</p>
        {children}
        <p>기본 레이아웃 끝</p>
      </body>
    </html>
  );
}
