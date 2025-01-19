from flask import Flask, request, jsonify
from dotenv import load_dotenv
import google.generativeai as genai
import os
from openai import OpenAI
import json
import time
import requests
import uuid
import re
import base64

load_dotenv()
app = Flask(__name__)

DATA = []  

def generate_uuid():
    return str(uuid.uuid4())

def storyGenerator(interests_field, country, time_frame):
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
    model = genai.GenerativeModel('models/gemini-1.5-pro-002')

    response = model.generate_content(
        contents=f"Help me look through the web for the biggest news about {interests_field} {country} which happened on {time_frame}. Then, for each story, write the headline and a very short summary(1-2 line) of it based on the news content in JSON format. Add in a 'prompt' parameter, which will be used to create the cover image for stable diffusion 3 model. Make the prompt innovative, realistic and enagaing so that users read our article. Remove all disclaimers. MAKE UNIQUE ARTICLES, DO NOT REPEAT THE SAME NEWS.",
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
            "summary": item.get("summary", "").strip(),
            "prompt": item.get("prompt", "").strip(),
        }
        cleaned_parsed_data.append(cleaned_item)
        
    return cleaned_parsed_data[:9] 

def img_gen(prompt):
    
    response = requests.post(
        f"https://api.stability.ai/v2beta/stable-image/generate/sd3",
        headers={
            "authorization": f"Bearer {os.environ['STABILITY_API_KEY']}",
            "accept": "image/*"
        },
        files={"none": ''},
        data={
            "prompt": prompt,
            "output_format": "jpeg",
        },
    )
        
    if response.status_code == 200:
        return base64.b64encode(response.content).decode('utf-8')
    else:
        return None
        
    
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
        image_url = img_gen(item["prompt"])
        
        news_item = {
            "id": generate_uuid(),
            "title": item["title"],
            "summary": item["summary"],
            "cover": image_url,
            "interests": interests,
            "region": region,
            "time_frame": time_frame
        }
        
        in_depth_article = generate_in_depth_article(item["title"])
        news_item["readTime"] = len(in_depth_article.split(" ")) / 265 * 60 + 12 
        
        enriched_news.append(news_item)
        
        news_item["content"] = in_depth_article
        
        DATA.append(news_item) 
        with open('data.json', 'w') as f:
            json.dump(DATA, f)

    return jsonify({'news': enriched_news})


@app.route('/news/<id>', methods=['GET'])
def get_news_item(id):
    for item in DATA:
        if item['id'] == id:
            
            # if the content starts with the title, remove it
            item["content"] = re.sub(rf"^{item['title']}", "", item["content"]).strip()
            
            return jsonify({
                "id": item['id'],
                "title": item['title'],
                "summary": item['summary'],
                "cover": item['cover'],
                "content": item['content'],
                "readTime": item['readTime']
            })

    return jsonify({'error': 'News item not found'}), 404


def generate_in_depth_article(title):
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
    model = genai.GenerativeModel('models/gemini-1.5-pro-002')
    
    response = model.generate_content(
        contents=f"Write an in-depth, engaging, and informative article on the topic: '{title}'. The article should explore various aspects of the topic, provide a good overview, and showcase different perspectives. Use all online sources available for insights. Make it captivating and interesting for the reader. DONT ADD THE TITLE!, I already have it. USE MARKDOWN FORMAT. AT LEAST 500 WORDS.",
        tools='google_search_retrieval'
    )
    
    return response.text

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=8080)
