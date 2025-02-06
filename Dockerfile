# ใช้ Node.js image เป็น Base
FROM node:18-alpine AS base

# กำหนด Directory ใน container
WORKDIR /app

# คัดลอก package.json และไฟล์ lock และติดตั้ง dependencies
COPY package.json yarn.lock* package-lock.json* ./
RUN \
  if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  else echo "No lockfile found, exiting." && exit 1; \
  fi

# คัดลอกซอร์สโค้ดทั้งหมด
COPY . .

# Build the Next.js application
RUN npm run build

# Production image
FROM node:18-alpine AS runner

# ตั้งค่าตัวแปรสภาพแวดล้อม
ENV NODE_ENV=production
ENV PORT=3584
ENV HOSTNAME="43.208.241.236"

# ใช้ non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# กำหนด Directory ภายใน container
WORKDIR /app

# คัดลอก build output และไฟล์อื่น ๆ
COPY --from=base /app/public ./public
COPY --from=base /app/.next/standalone ./
COPY --from=base /app/.next/static ./.next/static

# เปลี่ยนเป็น user ที่ไม่ใช้ root
USER appuser

# เปิด port ที่แอปพลิเคชันจะฟัง
EXPOSE 3584

# รันแอปพลิเคชัน
CMD ["node", "server.js"]
