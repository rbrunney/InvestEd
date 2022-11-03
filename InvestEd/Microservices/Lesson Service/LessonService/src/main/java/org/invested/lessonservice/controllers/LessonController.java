package org.invested.lessonservice.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/invested_lesson")
public class LessonController {

    @GetMapping("/test")
    public String test() {
        return "/test";
    }
}
