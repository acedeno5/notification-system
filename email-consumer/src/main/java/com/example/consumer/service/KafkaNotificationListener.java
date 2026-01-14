package com.example.consumer.service;

import com.example.consumer.model.NotificationMessage;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class KafkaNotificationListener {
    private static final Logger log = LoggerFactory.getLogger(KafkaNotificationListener.class);
    private final ObjectMapper mapper = new ObjectMapper();
    private final List<NotificationMessage> messages = new CopyOnWriteArrayList<>();

    @KafkaListener(topics = "notifications", groupId = "email-consumer-group")
    public void onMessage(String payload) {
        try {
            Map<String, Object> map = mapper.readValue(payload, new TypeReference<Map<String, Object>>(){});
            NotificationMessage m = new NotificationMessage(map);
            messages.add(0, m); // newest first
            if (messages.size() > 200) {
                messages.remove(messages.size() - 1);
            }
            log.info("Consumed notification: {}", map);
        } catch (Exception e) {
            log.error("Failed to parse notification payload", e);
        }
    }

    public List<NotificationMessage> recent() {
        return Collections.unmodifiableList(messages);
    }
}
