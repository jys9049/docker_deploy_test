# 1단계: 빌드
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm cache clean --force && npm install

COPY . .
RUN npm run build

# 2단계: 런타임 (경량)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./

EXPOSE 3000
CMD ["node", "server.js"]