FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
RUN rm /etc/nginx/conf.d/default.conf
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; index index.html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

# CHANGE THIS LINE BELOW: Note the added "/browser" at the end of the source path
COPY --from=build /app/dist/food-delivery/browser /usr/share/nginx/html

EXPOSE 80
