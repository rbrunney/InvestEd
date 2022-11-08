package org.invested.lessonservice.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.UUID;

@Entity
public class LessonSnippet {
    @Id
    private String id;
    private String infoSnippet;

    @ManyToOne
    @JoinColumn(name = "lesson_name", nullable = false)
    @JsonIgnore
    private Lesson lesson;
    // ///////////////////////////////////////////////////
    // Constructors

    public LessonSnippet() {}

    public LessonSnippet(String infoSnippet, Lesson lesson) {
        this.id = UUID.randomUUID().toString();
        this.infoSnippet = infoSnippet;
        this.lesson = lesson;
    }

    // ///////////////////////////////////////////////////
    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getInfoSnippet() {
        return infoSnippet;
    }

    public void setInfoSnippet(String infoSnippet) {
        this.infoSnippet = infoSnippet;
    }

    public Lesson getLesson() {
        return lesson;
    }

    public void setLesson(Lesson lesson) {
        this.lesson = lesson;
    }
}