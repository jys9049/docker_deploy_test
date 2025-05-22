export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
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
