package org.invested.lessonservice.services;

import org.invested.lessonservice.models.LessonSnippet;
import org.invested.lessonservice.repositories.LessonSnippetJPARepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LessonSnippetService {
    @Autowired
    private LessonSnippetJPARepository lessonSnippetRepo;


    public void saveSnippet(LessonSnippet snippet) {
        lessonSnippetRepo.save(snippet);
    }
}
