package org.invested.lessonservice.services;

import org.invested.lessonservice.models.DTOs.QuizQuestionDTO;
import org.invested.lessonservice.models.QuizQuestion;
import org.invested.lessonservice.repositories.QuizQuestionJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QuizQuestionService {

    @Autowired
    private QuizQuestionJPARepository quizQuestionRepo;

    public void saveQuestion(QuizQuestion question) {
        quizQuestionRepo.save(question);
    }
}
