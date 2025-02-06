# ใช้ Node.js image เวอร์ชัน 18 บน Alpine เพื่อให้ขนาดเล็ก
FROM node:18-alpine AS base

# กำหนด working directory ใน container
WORKDIR /app

# คัดลอกไฟล์ package.json และ lock files
COPY package.json yarn.lock* package-lock.json* ./

# ติดตั้ง dependencies โดยใช้ package manager
RUN \
  if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  else echo "No lockfile found, exiting." && exit 1; \
  fi

# คัดลอกซอร์สโค้ดทั้งหมดเข้าสู่ container
COPY . .

# Build the Next.js application
RUN npm run build

# Production image
FROM node:18-alpine AS runner

# ตั้งค่าตัวแปรสภาพแวดล้อม
ENV NODE_ENV=production
ENV PORT=3555           # เปลี่ยน PORT เป็น 3555
ENV HOSTNAME="0.0.0.0"

# ใช้ non-root user เพื่อความปลอดภัย
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# กำหนด working directory
WORKDIR /app

# คัดลอก build output และไฟล์อื่น ๆ
COPY --from=base /app/public ./public
COPY --from=base /app/.next/standalone ./
COPY --from=base /app/.next/static ./.next/static

# เปลี่ยนไปใช้ user ที่ไม่ใช่ root
USER appuser

# เปิด port ที่แอปพลิเคชันจะฟัง
EXPOSE 3555              # เปิดพอร์ต 3555

# รันแอปพลิเคชัน
CMD ["node", "server.js"]
