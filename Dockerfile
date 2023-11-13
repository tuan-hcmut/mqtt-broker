# Stage 1: Build stage to generate password hash
FROM eclipse-mosquitto:2.0.14 AS builder

# Set environment variables for the username and password
ENV MQTT_USERNAME ce_capstone
ENV MQTT_PASSWORD ce_capstone_2023

# Run commands to create a password file
RUN touch /mosquitto/config/passwd && \
    mosquitto_passwd -b /mosquitto/config/passwd ${MQTT_USERNAME} ${MQTT_PASSWORD}

# Stage 2: Final stage
FROM eclipse-mosquitto:2.0.14

# Copy the password file from the builder stage
COPY --from=builder /mosquitto/config/passwd /mosquitto/config/passwd

# Run commands to customize the configuration
RUN echo "listener 1883" > /mosquitto/config/mosquitto.conf

# Update the Mosquitto configuration for user authentication
RUN echo "allow_anonymous false" >> /mosquitto/config/mosquitto.conf
RUN echo "password_file /mosquitto/config/passwd" >> /mosquitto/config/mosquitto.conf

# Expose MQTT port
EXPOSE 1883
