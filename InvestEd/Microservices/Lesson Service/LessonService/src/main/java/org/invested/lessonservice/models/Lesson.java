package org.invested.lessonservice.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Document(collection = "lessons")
public class Lesson {

    @Id
    private String id;
    private String name;
    private String summary;
    private List<LessonSection> lessonInfo;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public List<LessonSection> getLessonInfo() {
        return lessonInfo;
    }

    public void setLessonInfo(List<LessonSection> lessonInfo) {
        this.lessonInfo = lessonInfo;
    }
}
