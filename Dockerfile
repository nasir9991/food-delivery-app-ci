# STAGE 1: Build
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# STAGE 2: Serve
FROM nginx:alpine
# 1. Remove default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# 2. Add custom config for Angular routing
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# 3. Copy build output (Ensure the folder name "food-delivery" matches your angular.json)
COPY --from=build /app/dist/food-delivery /usr/share/nginx/html

EXPOSE 80
