package org.invested.lessonservice.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.UUID;

@Entity
public class QuizQuestion {

    @Id
    private String id;
    private String question;
    private String correctAnswer;
    private String incorrectAnswer_1;
    private String incorrectAnswer_2;
    private String incorrectAnswer_3;
    private String incorrectAnswer_4;


    @ManyToOne
    @JoinColumn(name = "quiz_id", nullable = false)
    @JsonIgnore
    private LessonQuiz lessonQuiz;

    // /////////////////////////////////////////////////
    // Constructors

    public QuizQuestion() {}

    public QuizQuestion(String question, String correctAnswer, String incorrectAnswer_1, String incorrectAnswer_2, String incorrectAnswer_3, String incorrectAnswer_4, LessonQuiz lessonQuiz) {
        this.id = UUID.randomUUID().toString();
        this.question = question;
        this.correctAnswer = correctAnswer;
        this.incorrectAnswer_1 = incorrectAnswer_1;
        this.incorrectAnswer_2 = incorrectAnswer_2;
        this.incorrectAnswer_3 = incorrectAnswer_3;
        this.incorrectAnswer_4 = incorrectAnswer_4;
        this.lessonQuiz = lessonQuiz;
    }


    // /////////////////////////////////////////////////
    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public String getIncorrectAnswer_1() {
        return incorrectAnswer_1;
    }

    public void setIncorrectAnswer_1(String incorrectAnswer_1) {
        this.incorrectAnswer_1 = incorrectAnswer_1;
    }

    public String getIncorrectAnswer_2() {
        return incorrectAnswer_2;
    }

    public void setIncorrectAnswer_2(String incorrectAnswer_2) {
        this.incorrectAnswer_2 = incorrectAnswer_2;
    }

    public String getIncorrectAnswer_3() {
        return incorrectAnswer_3;
    }

    public void setIncorrectAnswer_3(String incorrectAnswer_3) {
        this.incorrectAnswer_3 = incorrectAnswer_3;
    }

    public String getIncorrectAnswer_4() {
        return incorrectAnswer_4;
    }

    public void setIncorrectAnswer_4(String incorrectAnswer_4) {
        this.incorrectAnswer_4 = incorrectAnswer_4;
    }

    public LessonQuiz getLessonQuiz() {
        return lessonQuiz;
    }

    public void setLessonQuiz(LessonQuiz lessonQuiz) {
        this.lessonQuiz = lessonQuiz;
    }
}
