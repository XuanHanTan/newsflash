import json

with open("data.json", "r") as f:
    DATA = json.load(f)
    
    
import base64

def create_image(id, base64_string):
    image = base64.b64decode(base64_string)
    with open(f'image_{id}.jpg', 'wb') as f:
        f.write(image)
        

for item in DATA:
    create_image(item['title'], item['cover'])
    
    

