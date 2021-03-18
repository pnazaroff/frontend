# Создаем приложение Angular
FROM node:alpine as  builder

USER node

RUN mkdir /home/node/.npm-global && mkdir /home/node/logs

ENV PATH=/home/node/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV HOME=/home/node

WORKDIR $HOME/app
# скопируеv файлы package.json и package-lock.json 
#COPY exadelBonus/package*.json ./
COPY package*.json ./
#RUN npm i -g npm
# Установка зависимостей
RUN npm install -g @angular/cli && npm cache clean --force

USER root
COPY . .
#COPY exadelBonus .
RUN npm install && ng build --prod --output-path=dist

# Развертываем приложение Angular на NGINX
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /home/node/app/dist /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
