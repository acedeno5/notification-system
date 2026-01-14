package com.example.consumer.controller;

import java.util.List;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.consumer.model.NotificationMessage;
import com.example.consumer.service.KafkaNotificationListener;

@RestController
@RequestMapping("/consumer")
public class ConsumerController {
    private final KafkaNotificationListener listener;

    public ConsumerController(KafkaNotificationListener listener) {
        this.listener = listener;
    }

    @GetMapping(path = "/api/messages", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<NotificationMessage>> messages() {
        return ResponseEntity.ok(listener.recent());
    }

    @GetMapping(path = "/ui", produces = MediaType.TEXT_HTML_VALUE)
    public String ui() {
        return """
                <html><head><meta charset="utf-8"><title>Consumer UI</title></head>
                <body><h1>Notifications</h1><div id="messages"></div>
                <script>
                async function poll(){
                    const r = await fetch('/consumer/api/messages');
                    const j = await r.json();
                    const el = document.getElementById('messages');
                    el.innerHTML = '';
                    j.forEach(m => {
                        const d = new Date(m.receivedAt);
                        const p = JSON.stringify(m.payload, null, 2);
                        el.innerHTML += '<div style="border:1px solid #ccc;margin:6px;padding:6px"><strong>' + d.toLocaleString() + '</strong><pre>' + p + '</pre></div>';
                    });
                }
                setInterval(poll,2000);
                poll();
                </script></body></html>
                """;
    }

    @GetMapping(path = "/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }
}
