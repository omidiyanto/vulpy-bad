FROM python:3.9.20-slim
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
RUN python db_init.py
EXPOSE 5000
CMD [ "python"," ","vulpy.py"]