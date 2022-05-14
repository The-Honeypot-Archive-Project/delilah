FROM python:slim

RUN apt update && apt install -y sqlite3

COPY Delilah.py /delilah/Delilah.py
COPY requirements.txt /delilah/requirements.txt

WORKDIR /delilah

RUN pip install -r requirements.txt

CMD ["python3","Delilah.py"]
