package org.invested.lessonservice.controllers;

import org.invested.lessonservice.models.DTOs.LessonQuizDTO;
import org.invested.lessonservice.models.DTOs.LessonSnippetDTO;
import org.invested.lessonservice.models.DTOs.QuizQuestionDTO;
import org.invested.lessonservice.models.Lesson;
import org.invested.lessonservice.models.LessonQuiz;
import org.invested.lessonservice.models.LessonSnippet;
import org.invested.lessonservice.models.QuizQuestion;
import org.invested.lessonservice.services.LessonQuizService;
import org.invested.lessonservice.services.LessonService;
import org.invested.lessonservice.services.LessonSnippetService;
import org.invested.lessonservice.services.QuizQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
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

    @Autowired
    private QuizQuestionService quizQuestionService;

    @Autowired
    private LessonSnippetService lessonSnippetService;

    @PostMapping()
    public ResponseEntity<Map<String, Object>> createLesson(@RequestBody Lesson lesson) {
        lessonService.saveLesson(lesson);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @PostMapping("/create_quiz")
    public ResponseEntity<Map<String, Object>> createQuiz(@RequestBody LessonQuizDTO quiz) {
        lessonQuizService.saveQuiz(new LessonQuiz(quiz.getInvestmentReward(),
                lessonService.getLesson(quiz.getLessonName()),
                new ArrayList<>()));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/create_quiz_question")
    public ResponseEntity<Map<String, Object>> createQuizQuestion(@RequestBody QuizQuestionDTO question) {
        quizQuestionService.saveQuestion(new QuizQuestion(
                question.getQuestion(),
                question.getCorrectAnswer(),
                question.getIncorrectAnswer_1(),
                question.getIncorrectAnswer_2(),
                question.getIncorrectAnswer_3(),
                question.getIncorrectAnswer_4(),
                lessonQuizService.getQuiz(question.getQuizId())
        ));
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/create_snippet")
    public ResponseEntity<Map<String, Object>> createSnippet(@RequestBody LessonSnippetDTO snippet) {
        lessonSnippetService.saveSnippet(new LessonSnippet(snippet.getInfoSnippet(), lessonService.getLesson(snippet.getLessonName())));
        return new ResponseEntity<>(HttpStatus.OK);
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

    @GetMapping("/get_quiz/{id}")
    public ResponseEntity<Map<String, Object>> getQuiz(@PathVariable String id) {

        Map<String, Object> response = new HashMap<>() {{
            put("message", id + " has been retrieved successfully");
            put("results", lessonQuizService.getQuiz(id));
            put("date-time", LocalDateTime.now());
        }};

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
