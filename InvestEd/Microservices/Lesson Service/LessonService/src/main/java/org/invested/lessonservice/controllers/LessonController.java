package org.invested.lessonservice.controllers;

import org.invested.lessonservice.models.Lesson;
import org.invested.lessonservice.services.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/invested_lesson")
public class LessonController {

    @Autowired
    private LessonService lessonService;

    @PostMapping()
    public ResponseEntity<Map<String, Object>> createLesson(@RequestBody Lesson lesson) {
        lessonService.saveLesson(lesson);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @GetMapping("/{lessonName}")
    public ResponseEntity<Map<String, Object>> getLesson(@PathVariable String lessonName) {
        Map<String, Object> response = new HashMap<>() {{
            put("message", lessonName + " has been retrieved successfully");
            put("results", lessonService.getLesson(lessonName));
            put("date-time", LocalDateTime.now());
        }};
        
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
