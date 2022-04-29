FROM python:3.8-slim

RUN useradd --create-home --shell /bin/bash app_user

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "./consumer.py"]