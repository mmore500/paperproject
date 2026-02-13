FROM python:3.10-slim

WORKDIR /usr/src/app

COPY . .

RUN python3 -m pip install --upgrade pip setuptools
RUN python3 -m pip install .

CMD ["python3"]
