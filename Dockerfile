FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
# Copy your build files
COPY --from=build /app/dist/food-delivery /usr/share/nginx/html

# Add this line to fix the "Welcome to Nginx" default page issue
RUN rm /etc/nginx/conf.d/default.conf

# Create a simple config to redirect all traffic to index.html
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; index index.html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

EXPOSE 80
