FROM python:3.12-alpine
RUN adduser -D -u 10001 app
WORKDIR /app
COPY server.py .
USER app
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=3s --retries=3 CMD wget -q -O- http://127.0.0.1:8080/health/ready || exit 1
CMD ["python","server.py"]
