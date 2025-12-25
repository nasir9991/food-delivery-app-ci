FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
# 1. Clear the default Nginx landing page
RUN rm /etc/nginx/conf.d/default.conf

# 2. Add a config that supports Angular routing
RUN echo 'server { \
    listen 80; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

# 3. Copy your specific build folder (check if it is "food-delivery")
COPY --from=build /app/dist/food-delivery /usr/share/nginx/html

EXPOSE 80
