FROM ubuntu:24.04
WORKDIR /app
RUN apt update && apt install fortune-mod cowsay netcat-openbsd -y
ENV PATH="$PATH:/usr/games"
COPY wisecow.sh .
RUN chmod +x wisecow.sh
EXPOSE 4499
CMD ["./wisecow.sh"]