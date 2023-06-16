FROM locustio/locust

ENV LOCUST_DIR locust

RUN mkdir -p "${LOCUST_DIR}" \
    && chown -R locust:locust "${LOCUST_DIR}" \
    && chmod -R g+rwx "${LOCUST_DIR}"

COPY requirements.txt "${LOCUST_DIR}"/requirements.txt
COPY locustfile.py locustfile.py 

RUN pip install --upgrade pip
RUN pip3 install -r "${LOCUST_DIR}"/requirements.txt




