# Stage 1: build
FROM node:18-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

# copy everything and pick up the .env at build time
COPY . .
# explicitly inject build‑time env into the React build:
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

RUN npm run build

# Stage 2: serve with nginx
FROM nginx:1.25-alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
