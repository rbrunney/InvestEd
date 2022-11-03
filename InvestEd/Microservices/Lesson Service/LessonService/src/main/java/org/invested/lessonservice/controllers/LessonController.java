package org.invested.lessonservice.controllers;

import org.invested.lessonservice.models.Lesson;
import org.invested.lessonservice.models.LessonQuiz;
import org.invested.lessonservice.services.LessonQuizService;
import org.invested.lessonservice.services.LessonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/invested_lesson")
public class LessonController {

    @Autowired
    private LessonService lessonService;

    @Autowired
    private LessonQuizService lessonQuizService;

    @PostMapping()
    public ResponseEntity<Map<String, Object>> createLesson(@RequestBody Lesson lesson) {
        lessonService.saveLesson(lesson);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @PostMapping("/make_quiz")
    public ResponseEntity<Map<String, Object>> createQuiz(@RequestBody LessonQuiz quiz) {
        quiz.setId(UUID.randomUUID().toString());
        lessonQuizService.saveQuiz(quiz);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/get_quiz/{id}")
    public ResponseEntity<Map<String, Object>> getQuiz(@PathVariable String id) {

        Map<String, Object> response = new HashMap<>() {{
            put("message", id + " has been retrieved successfully");
            put("results", lessonQuizService.getQuiz(id));
            put("date-time", LocalDateTime.now());
        }};

        return new ResponseEntity<>(response, HttpStatus.OK);
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
