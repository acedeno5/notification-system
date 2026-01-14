package com.example.consumer.model;

import java.time.Instant;
import java.util.Map;

public class NotificationMessage {
    private final Instant receivedAt;
    private final Map<String, Object> payload;

    public NotificationMessage(Map<String, Object> payload) {
        this.receivedAt = Instant.now();
        this.payload = payload;
    }

    public Instant getReceivedAt() {
        return receivedAt;
    }

    public Map<String, Object> getPayload() {
        return payload;
    }
}
