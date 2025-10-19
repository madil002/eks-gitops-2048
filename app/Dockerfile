FROM busybox:stable
RUN adduser -D static
USER static
WORKDIR /home/static
COPY . .
CMD ["busybox", "httpd", "-f", "-p", "3000"]
