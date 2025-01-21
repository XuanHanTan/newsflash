A project done for Hack n Roll 2025! (24 hour hackathon)

## Inspiration
"News? So many perspectives...I don't want to read long articles..."
[Most young people do not want to read the news] (https://www.thoughtco.com/why-dont-young-people-read-the-news-2074000) due to our short attention span. However, it is important to be informed of current affairs, or learn more about our topics of interests. Moreover, news networks might also have biases, which might affect their objectivity. As a result, readers might be led down a rabbit hole and only have a one-sided perspective. Hence, we developed an app which scours the web for your interested topics through multiple sources. Then, the app displays it in a bite-sized manner, keeping you informed on the go and empowering users with a well-rounded summary. 
As students, we liked the idea of flash cards as it was a digestible way of displaying information. Hence, we decided to combine that idea with lengthy news articles, presenting them in a flash-card manner.


## What it does
- Makes staying informed easier and more efficient
Key Features:
- Bite-sized, easy-to-digest news summaries
- Curated based on user interests
- Focus on balance by pulling stories from multiple sources
- Avoids bias by offering a variety of viewpoints
- Helps users form a well-rounded understanding of current events
Benefits:
- Personalized news experience
- Avoids overwhelm
- Reduces exposure to one-sided narratives


## How we built it
- Google Gemini AI API for scouring the web and summarising
- Stable Diffusion for thumbnail image generation
- Flutter for the app development
- Python for the APIs


## Challenges we ran into
- Initially used a Python package to get trending news from Google.
- Discovered the package only returned RSS links, which Gemini AI couldn’t process.
- Pivoted to retrieving news directly from Gemini AI.
- Decided to create thumbnail images using OpenAI's DALL-E 3.
- Encountered rate limits with DALL-E 3, impacting thumbnail production. (it's also expensive to use)
- Pivoted again to using Stable Diffusion for generating thumbnails.


## Accomplishments that we're proud of
- Finishing the app in such a short amount of time despite the problems faced.
- Sleep


## What we learned
- Creating an API
- AI Integration
- Creating an app using Flutter
- AI calls are very expensive
- Google's Google couldn't Google
- Human's ability to lock in focus and sustain attention on tasks is a hallmark of our cognitive capabilities. This ability, often referred to as "deep focus" or "flow," allows individuals to immerse themselves fully in an activity, achieving higher levels of productivity, creativity, and problem-solving. This is us. 


## What's next for NewsFlash
We want to include more niche topics so that people with specific interests can feel seen and heard. We could also work on a social feature so users can share and discuss stories, building a community of thoughtful, informed readers. 
