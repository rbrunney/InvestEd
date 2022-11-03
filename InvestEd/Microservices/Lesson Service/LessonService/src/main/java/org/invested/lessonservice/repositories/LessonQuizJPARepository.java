package org.invested.lessonservice.repositories;

import org.invested.lessonservice.models.LessonQuiz;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LessonQuizJPARepository extends JpaRepository<LessonQuiz, String> {
}
