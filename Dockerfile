FROM nginx:1.14.1-alpine

EXPOSE 80

COPY dist /usr/share/nginx/html
