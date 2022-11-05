package org.invested.lessonservice.services;

import org.invested.lessonservice.models.Lesson;
import org.invested.lessonservice.repositories.LessonJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LessonService {

    @Autowired
    private LessonJPARepository lessonRepo;

    public void saveLesson(Lesson lesson) {
        lessonRepo.save(lesson);
    }

    public Lesson getLesson(String lessonName) {
        return lessonRepo.getLessonByName(lessonName);
    }
}
