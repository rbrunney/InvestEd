package org.invested.lessonservice.controller;

import org.invested.lessonservice.models.Lesson;
import org.invested.lessonservice.repository.LessonRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/invested_lesson")
public class LessonController {
    @Autowired
    private LessonRepo lessonRepo;

    @PostMapping("/create_lesson")
    public ResponseEntity<String> createLesson(@RequestBody Lesson lesson) {
        lessonRepo.save(lesson);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @GetMapping("/{lessonName}")
    public ResponseEntity<Lesson> getLesson(@PathVariable String lessonName) {
        return new ResponseEntity<>(lessonRepo.getLessonByName(lessonName), HttpStatus.OK);
    }

//    @PutMapping("/{lessonName}/{sectionName}/{username}")
//    public ResponseEntity<String> completeLesson(@PathVariable String lessonName, @PathVariable String sectionName, @PathVariable String username) {
//        lessonRepo.
//    }
}
