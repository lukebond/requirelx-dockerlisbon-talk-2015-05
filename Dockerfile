FROM gliderlabs/alpine:3.1
RUN apk --update add nodejs
ADD app.js /opt/app/app.js
RUN cd /opt/app
EXPOSE 9000
CMD ["node", "/opt/app/app.js"]
