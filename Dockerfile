FROM node:18

WORKDIR /app

RUN npm install -g npm@latest
RUN npm install -g expo-cli @expo/ngrok@^4.1.0

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 19000 19001 19002 8081

ENV EXPO_DEVTOOLS_LISTEN_ADDRESS=0.0.0.0
ENV REACT_NATIVE_PACKAGER_HOSTNAME=0.0.0.0

CMD ["npx", "expo", "start", "--tunnel"]