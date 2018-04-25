# FROM python:3.5
FROM python:3.6

ENV PYTHONUNBUFFERED 1

# Requirements have to be pulled and installed here, otherwise caching won't work
ADD requirements.txt /requirements.txt

RUN pip install -r /requirements.txt \
    && groupadd -r django \
    && useradd -r -g django django

COPY project /app
RUN chown -R django /app
RUN mkdir -p /var/ypgforum /var/ypgforum_static
ADD gunicorn.sh /gunicorn.sh
ADD entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh \
    && sed -i 's/\r//' /gunicorn.sh \
    && chmod +x /entrypoint.sh \
    && chown django /var/ypgforum \
    && chown django /var/ypgforum_static \
    && chown django /entrypoint.sh \
    && chmod +x /gunicorn.sh \
    && chown django /gunicorn.sh
EXPOSE 5000
WORKDIR /app
VOLUME ['/var/ypgforum']

# ENTRYPOINT ["/entrypoint.sh"]
