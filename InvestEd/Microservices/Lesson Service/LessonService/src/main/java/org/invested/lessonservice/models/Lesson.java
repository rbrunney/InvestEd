package org.invested.lessonservice.models;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;

@Entity
public class Lesson {

    @Id
    private String name;
    private String description;

    @OneToOne(mappedBy = "lesson")
    private LessonQuiz quizId;

    // ////////////////////////////////////////////////////

    public Lesson() {}

    public Lesson(String name, String description, LessonQuiz quizId) {
        this.name = name;
        this.description = description;
        this.quizId = quizId;
    }

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

    public LessonQuiz getQuizId() {
        return quizId;
    }

    public void setQuizId(LessonQuiz quizId) {
        this.quizId = quizId;
    }
}
