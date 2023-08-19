#node block

FROM node:alpine3.16 as nodework
WORKDIR /mpapp
COPY . /mpapp
RUN apk add --no-cache python3
RUN apk add --no-cache make gcc g++
RUN npm cache clean --force
RUN npm install
COPY . .
RUN npm run build

#nginx block
FROM nginx:1.23-alpine

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

COPY --from=nodework /mpapp/build .
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
