FROM python:3.11-slim
WORKDIR /app
# When the build context is the repository root (.), the source files are in ./sample-app
COPY sample-app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY sample-app/app.py ./
EXPOSE 8080
CMD ["python", "app.py"]
