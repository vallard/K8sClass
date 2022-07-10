FROM node:15.11.0 as react-build
WORKDIR /app
COPY . ./
RUN npm install
RUN npm run build

FROM nginx:alpine
COPY --from=react-build /app/build /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
