import requests
import urllib.parse
from dotenv import load_dotenv
import os

load_dotenv()
geocode_url = "https://graphhopper.com/api/1/geocode?"
route_url = "https://graphhopper.com/api/1/route?"
loc1 = "Washington, D.C."
loc2 = "Baltimore, Maryland"
key = os.environ["WEBEX_TOKEN"]


url = geocode_url + urllib.parse.urlencode({"q":loc1, "limit":"1", "key":key})
print(url)

replydata = requests.get(url)
json_data = replydata.json()
json_status = replydata.status_code

print(json_data)
