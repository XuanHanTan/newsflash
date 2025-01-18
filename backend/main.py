from flask import Flask, request, jsonify
from openai import OpenAI
from dotenv import load_dotenv
import google.generativeai as genai
import os
import json

load_dotenv()
app = Flask(__name__)

def storyGenerator(interest_field, country, time_frame):
    genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
    model = genai.GenerativeModel('models/gemini-1.5-pro-002')

    response = model.generate_content(contents=f"Help me look through the web for the biggest news about {interest_field} {country} {time_frame}. Then, for each story, write the headline and a medium-length paragraph summary of it based on the news content in json format. Remove all disclaimers",
                                    tools='google_search_retrieval')
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
            "headline": item.get("headline", "").strip(),
            "summary": item.get("summary", "").strip()
        }
        cleaned_parsed_data.append(cleaned_item)
    return cleaned_parsed_data

#AI image generation
def img_gen(title):
    api_key = os.getenv('OPENAI_API_KEY')
    client = OpenAI(api_key=api_key)
    prompt = f'Based on this news title, create an image thumbnail: {title}'
    response = client.images.generate(
        #model="",
        prompt=prompt,
        size="1024x1024",
        quality="standard",
        n=1,
    )

    return response.data[0].url

@app.route('/news', methods=['GET'])
def get_news():
    interests = request.args.get('interests', '')
    country = request.args.get('country', '')
    time_frame = request.args.get('time_frame', '')
    if not interests or not country or not time_frame:
        return jsonify({'error': 'Missing required parameters: interests, country, or time_frame'}), 400
    
    news_content = storyGenerator(interests, country, time_frame)
    cleaned_news_content = clean_news_data(news_content)

    for item in cleaned_news_content:
        image_url = img_gen(item["headline"])
        item["image"] = image_url

    return jsonify({'news': cleaned_news_content})

if __name__ == '__main__':
    app.run(debug=True)

#sample usage: http://127.0.0.1:5000/news?interests=technology&country=singapore&time_frame=today

