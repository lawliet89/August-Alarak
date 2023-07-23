FROM python:3.11-alpine3.17 AS builder

RUN pip install pipenv

# Tell pipenv to create venv in the current directory
ENV PIPENV_VENV_IN_PROJECT=1

# Pipfile contains requests
ADD Pipfile.lock Pipfile /usr/src/

WORKDIR /usr/src

RUN pipenv install --deploy --verbose

FROM python:3.11-alpine3.17 AS runtime

RUN mkdir -v /usr/src/.venv

COPY --from=builder /usr/src/.venv/ /usr/src/.venv/

COPY . /usr/src

WORKDIR /usr/src/

CMD ["./.venv/bin/python", "-m", "telegram_audio.py"]
