class NewsArticle:
    def __init__(self, title: str, authors: list, publisher:str , publish_date: str, summary: str, story_link: str, thumbnail_link: str):
        self.title = title
        self.authors = authors
        self.publisher = publisher
        self.publish_date = publish_date
        self.summary = summary
        self.story_link = story_link
        self.thumbnail_link = thumbnail_link

    def to_json(self):
        return {
            'title' : self.title,
            'authors' : self.authors,
            'publisher' : self.publisher,
            'publish_date' : self.publish_date,
            'summary' : self.summary,
            'story_link' : self.story_link,
            'thumbnail_link' : self.thumbnail_link,
        }