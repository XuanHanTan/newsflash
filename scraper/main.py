from flask import Flask, request, jsonify
from pygooglenews import GoogleNews
import uuid
import time
#from newspaper import Article

app = Flask(__name__)

def generate_uuid():
    return str(uuid.uuid4())

'''def fetch_article_summary(url):
    try:
        article = Article(url)
        article.download()
        article.parse()
        article.nlp()
        return article.summary()
    except Exception as e:
        print(f"Error fetching summary for {url}: {e}")
        return "Summary not available."'''

def get_stories(interests):
    stories = []
    gn = GoogleNews()
    search_results = gn.search(interests)
    news_items = search_results['entries']
    
    for item in news_items:
        story = {
            'id': generate_uuid(), 
            'time': int(time.mktime(item.published_parsed) * 1000), 
            'cover': item.link,  
            'title': item.title,
            #'summary': fetch_article_summary(item.link)
            'summary': item.summary
        }
        stories.append(story)
    
    return stories

@app.route('/news', methods=['GET'])
def get_news():
    interests = request.args.get('interests', '')
    
    if not interests:
        return jsonify({'error': 'No interests provided'}), 400
    news = get_stories(interests)
    
    return jsonify({'news': news})

if __name__ == '__main__':
    app.run(debug=True)
