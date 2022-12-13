package org.invested.lessonservice.models;

import java.util.List;

public class LessonSection {
    private String header;
    private List<String> snippets;

    public String getHeader() {
        return header;
    }

    public void setHeader(String header) {
        this.header = header;
    }

    public List<String> getSnippets() {
        return snippets;
    }

    public void setSnippets(List<String> snippets) {
        this.snippets = snippets;
    }
}
