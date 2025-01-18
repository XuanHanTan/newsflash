from dotenv import load_dotenv
import google.generativeai as genai
import os

load_dotenv()

genai.configure(api_key=os.environ["API_KEY"])
model = genai.GenerativeModel('models/gemini-1.5-pro-002')

interest_field = 'tech'
country = 'IN Singapore'
time_frame = 'today'

response = model.generate_content(contents=f"Help me look through the web for the biggest news about {interest_field} {country} {time_frame}. Then, for each story, write the headline and a medium-length paragraph summary of it based on the news content in json format. Remove all disclaimers",
                                  tools='google_search_retrieval')
print(response.text)

#have an option for tags (eg options like country/interest) 
#in json
