package org.invested.lessonservice.repositories;

import org.invested.lessonservice.models.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuizQuestionJPARepository extends JpaRepository<QuizQuestion, String> {
}
