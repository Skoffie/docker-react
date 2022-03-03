#FROM node:16-alpine as builder
#WORKDIR '/app'
#COPY package.json .
#RUN npm install
#COPY . .
#RUN npm run build

#FROM nginx
#EXPOSE 80
#COPY --from=builder /app/build /usr/share/nginx/html

FROM node:16-alpine

WORKDIR /opt/ng
COPY package.json package-lock.json ./
RUN npm install

ENV PATH="./node_modules/.bin:$PATH"

COPY . ./
RUN ng build --prod

FROM nginx:1.18-alpine
EXPOSE 80

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=0 /opt/ng/dist/angular-universal-app/browser /usr/share/nginx/html