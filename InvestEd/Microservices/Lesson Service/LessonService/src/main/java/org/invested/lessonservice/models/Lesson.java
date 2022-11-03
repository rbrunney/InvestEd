package org.invested.lessonservice.models;

import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.CascadeType;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.List;

@Entity
public class Lesson {

    @Id
    private String name;
    private String description;
    @OneToMany(mappedBy = "lesson")
    private List<LessonQuiz> quizzes;

    @OneToMany(mappedBy = "lesson")
    private List<LessonSnippet> info;

    // ////////////////////////////////////////////////////

    public Lesson() {}

    // ////////////////////////////////////////////////////
    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<LessonQuiz> getQuizzes() {
        return quizzes;
    }

    public void setQuizzes(List<LessonQuiz> quiz) {
        this.quizzes = quiz;
    }

    public List<LessonSnippet> getInfo() {
        return info;
    }

    public void setInfo(List<LessonSnippet> info) {
        this.info = info;
    }
}
