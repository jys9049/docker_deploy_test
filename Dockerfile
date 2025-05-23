# 1단계: 빌드
FROM node:18-alpine AS builder

# git action 워크플로우의 --build-arg 로부터 값을 전달받을 ARG 변수 선언
ARG BUILD_ARG_NEXT_PUBLIC_TEST_KEY
# 전달받은 ARG 값을 실제 Next.js가 인식할 환경 변수로 설정
ENV NEXT_PUBLIC_TEST_KEY=$BUILD_ARG_NEXT_PUBLIC_TEST_KEY

# app 폴더 생성 (및 이후 명령어들의 기본 경로로 설정)
WORKDIR /app 
# package.json, package-lock.json 를 /app (현재 WORKDIR)으로 복사
COPY package*.json ./
# 의존성 설치 (package-lock.json이 있다면 이를 기반으로 설치.)
RUN npm ci
# 전체 소스 코드 및 설정 파일 등을 /app (현재 WORKDIR)으로 복사
COPY . .
# .next 빌드 폴더 제거 (이전 빌드 캐시나 로컬 빌드 결과물과의 충돌 방지, 깨끗한 Next.js 빌드 환경 조성)
RUN rm -rf .next
# build 실행 (package.json의 "build" 스크립트, 즉 "next build"를 실행하여 프로덕션 빌드 생성)
RUN npm run build

# 2단계: 런타임 (경량)
FROM node:18-alpine AS runner
# app 폴더 생성 (및 이후 명령어들의 기본 경로로 설정)
WORKDIR /app
# production 모드 (Node.js 및 Next.js가 프로덕션 모드로 동작하도록 환경 변수 설정)
ENV NODE_ENV=production
# 보안을 위해 non-root 유저(nextjs)와 그룹(nodejs) 생성
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 1단계 빌드 스테이지(builder)에 있는 /app/public 폴더를 현재 스테이지의 /app/public 으로 복사
COPY --from=builder /app/public ./public
# 1단계 빌드 스테이지(builder)에 있는 /app/.next/standalone 폴더 안의 내용물을 현재 스테이지의 /app 으로 복사
# (server.js, 최소화된 node_modules, .next/server 폴더 등이 복사됨)
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
# 1단계 빌드 스테이지(builder)에 있는 /app/.next/static 폴더를 현재 스테이지의 /app/.next/static 으로 복사
# (클라이언트 사이드 에셋, 이미지 등 정적 파일)
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# 애플리케이션 실행 유저를 nextjs로 변경
USER nextjs

# 컨테이너가 3000번 포트를 외부에 노출할 것임을 명시 (실제 포트 매핑은 docker-compose.yml에서)
EXPOSE 3000

# 컨테이너 시작 시 실행될 기본 명령어 (standalone 서버 실행)
CMD ["node", "server.js"]