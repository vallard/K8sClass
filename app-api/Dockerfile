# A Dockerfile is a text document that contains all the commands
# a user could call on the command line to assemble an image.

FROM python:3.9.4-slim-buster

# Our Debian with python is now installed.
# Imagine we have folders /sys, /tmp, /bin etc. there
# like we would install this system on our laptop.
RUN apt update && apt install -y  \
  netcat \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir code

# We create folder named code for our stuff.

WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY ./run.sh /code/run.sh
COPY ./alembic.ini /code/alembic.ini
COPY ./alembic /code/alembic
COPY ./app /code/app

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--reload",  "--host",  "0.0.0.0",  "--port",  "80"]
