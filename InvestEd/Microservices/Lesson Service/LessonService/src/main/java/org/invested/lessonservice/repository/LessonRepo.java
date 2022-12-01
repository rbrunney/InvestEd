package org.invested.lessonservice.repository;

import org.invested.lessonservice.models.Lesson;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LessonRepo extends MongoRepository<Lesson, String> {

    Lesson getLessonByName(String name);
}
