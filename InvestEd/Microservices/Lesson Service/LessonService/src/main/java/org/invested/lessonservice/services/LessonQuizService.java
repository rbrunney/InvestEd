package org.invested.lessonservice.services;

import org.invested.lessonservice.models.LessonQuiz;
import org.invested.lessonservice.repositories.LessonQuizJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LessonQuizService {
    @Autowired
    private LessonQuizJPARepository lessonQuizRepo;

    public void saveQuiz(LessonQuiz quiz) {
        lessonQuizRepo.save(quiz);
    }

    public LessonQuiz getQuiz(String id) {
        return  lessonQuizRepo.getLessonQuizById(id);
    }
}
