package org.invested.lessonservice.repositories;

import org.invested.lessonservice.models.LessonSnippet;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LessonSnippetJPARepository extends JpaRepository<LessonSnippet, String> {
}
