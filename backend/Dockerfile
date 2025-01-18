FROM python:3.12-slim

ENV PYTHONUNBUFFERED True

#RUN apt-get update && apt-get install -y redis-server && rm -rf /var/lib/apt/lists/*
#RUN echo "daemonize yes" >> /etc/redis/redis.conf

WORKDIR /app
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

EXPOSE 8080


COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Start Redis server and the Flask application
CMD ["/app/start.sh"]

