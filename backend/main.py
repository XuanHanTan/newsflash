from flask import Flask, request, jsonify
from dotenv import load_dotenv
import google.generativeai as genai
import os
from openai import OpenAI
import json
import time
import uuid

load_dotenv()
app = Flask(__name__)

DATA = []  

def generate_uuid():
    return str(uuid.uuid4())

def storyGenerator(interest_field, country, time_frame):
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
    model = genai.GenerativeModel('models/gemini-1.5-pro-002')

    response = model.generate_content(
        contents=f"Help me look through the web for the biggest news about {interest_field} {country} which happened on {time_frame}. Then, for each story, write the headline and a medium-length paragraph summary of it based on the news content in JSON format. Remove all disclaimers",
        tools='google_search_retrieval'
    )
    return response.text

def clean_news_data(raw_data):
    cleaned_data = raw_data.replace('```json\n', '').replace('```', '').strip()

    try:
        parsed_data = json.loads(cleaned_data)
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")
        parsed_data = []

    cleaned_parsed_data = []
    for item in parsed_data:
        cleaned_item = {
            "title": item.get("headline", "").strip(),
            "summary": item.get("summary", "").strip()
        }
        cleaned_parsed_data.append(cleaned_item)
    return cleaned_parsed_data[:5] 

def img_gen(title, summary):
    api_key = os.getenv('OPENAI_API_KEY')
    client = OpenAI(api_key=api_key)
    prompt = f"Create an image inspired by a news story about {title}. The story should convey this: {summary} without any text or words involved."
    response = client.images.generate(
        prompt=prompt,
        size="1024x1024",
        quality="standard",
        n=1,
    )
    return response.data[0].url

@app.route('/news', methods=['GET'])
def get_news():
    interests = request.args.get('interests', '')
    region = request.args.get('region', '')
    time_frame = request.args.get('time_frame', '')
    if region == '' or region == 'world' or region == 'global':
        region = 'Find the latest news from around the world.'
    else:
        region = f'Find the latest news from {region}.'
        
    if not interests or not time_frame:
        return jsonify({'error': 'Missing required parameters: interests, or time_frame'}), 400

    global DATA

    cached_data = [item for item in DATA if item.get('interests') == interests and
                   item.get('region') == region and item.get('time_frame') == time_frame]
    if cached_data:
        return jsonify({'news': cached_data})

    raw_news = storyGenerator(interests, region, time_frame)
    cleaned_news = clean_news_data(raw_news)

    enriched_news = []
    for item in cleaned_news:
        image_url = img_gen(item["title"], item["summary"])
        news_item = {
            "id": generate_uuid(),
            "title": item["title"],
            "summary": item["summary"],
            "cover": image_url,
            "interests": interests,
            "region": region,
            "time_frame": time_frame
        }
        enriched_news.append(news_item)
        DATA.append(news_item) 

    return jsonify({'news': enriched_news})


@app.route('/news/<id>', methods=['GET'])
def get_news_item(id):
    for item in DATA:
        if item['id'] == id:
            title = item['title']
            
            in_depth_article = generate_in_depth_article(title)
            
            return jsonify({
                "id": item['id'],
                "title": item['title'],
                "summary": item['summary'],
                "cover": item['cover'],
                "content": in_depth_article
            })

    return jsonify({'error': 'News item not found'}), 404


def generate_in_depth_article(title):
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
    model = genai.GenerativeModel('models/gemini-1.5-pro-002')
    
    response = model.generate_content(
        contents=f"Write an in-depth, engaging, and informative article on the topic: '{title}'. The article should explore various aspects of the topic, provide a good overview, and showcase different perspectives. Use all online sources available for insights. Make it captivating and interesting for the reader. USE MARKDOWN FORMAT.",
        tools='google_search_retrieval'
    )

    return response.text

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8080)
