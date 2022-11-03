package org.invested.lessonservice.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
public class LessonQuiz {

    @Id
    private String id;
    private double investmentReward;

    @ManyToOne
    @JoinColumn(name="lesson_name", nullable = false)
    @JsonIgnore
    private Lesson lesson;

    @OneToMany(mappedBy = "lessonQuiz")
    private List<QuizQuestion> questions = new ArrayList<>();

    // /////////////////////////////////////////////////////////////
    // Constructors

    public LessonQuiz() {}

    public LessonQuiz(double investmentReward, Lesson lesson, List<QuizQuestion> questions) {
        this.id = UUID.randomUUID().toString();
        this.investmentReward = investmentReward;
        this.lesson = lesson;
        this.questions = questions;
    }


    // /////////////////////////////////////////////////////////////
    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getInvestmentReward() {
        return investmentReward;
    }

    public void setInvestmentReward(double investmentReward) {
        this.investmentReward = investmentReward;
    }

    public Lesson getLesson() {
        return lesson;
    }

    public void setLesson(Lesson lesson) {
        this.lesson = lesson;
    }

    public List<QuizQuestion> getQuestions() {
        return questions;
    }

    public void setQuestions(List<QuizQuestion> questions) {
        this.questions = questions;
    }
}
