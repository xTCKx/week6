FROM python:trixie
WORKDIR /app/cinnamoroll

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
COPY app/ .
EXPOSE 8080

# Setup an app user so the container doesn't run as the root user
RUN useradd app-cinnamoroll
USER app-cinnamoroll

CMD ["python", "app.py"]