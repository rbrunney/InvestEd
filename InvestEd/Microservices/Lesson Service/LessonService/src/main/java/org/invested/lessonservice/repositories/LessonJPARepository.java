package org.invested.lessonservice.repositories;

import org.invested.lessonservice.models.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LessonJPARepository extends JpaRepository<Lesson, String> {
    Lesson getLessonByName(String lessonName);
}
