import os
import sys
import urllib

import praw  # pip install praw


template = """
module OnionData exposing (..)


type Source = TheOnion | NotTheOnion

posts = [ %s
        ]
"""


if len(sys.argv) != 5:
    print(f"usage: {sys.argv[0]} AMOUNT CLIENT_ID CLIENT_SECRET USER_AGENT")
    sys.exit(1)

__, amount, client_id, client_secret, user_agent = sys.argv
amount = int(amount)

r = praw.Reddit(
    client_id=client_id,
    client_secret=client_secret,
    user_agent=user_agent,
)

theonion = []
for post in r.subreddit("theonion").top():
    address = urllib.parse.urlparse(post.url).netloc
    if not address.endswith("theonion.com"):
        print(address)
        continue
    theonion.append((post.title.replace('"', "”"), post.url))
    if len(theonion) == amount:
        break

nottheonion = []
for post in r.subreddit("nottheonion").top(limit=amount):
    nottheonion.append((post.title.replace('"', "”"), post.url))

out = []
for title, url in theonion:
    out.append(f'{{ title = "{title}", url = "{url}", source = TheOnion }}')
for title, url in nottheonion:
    out.append(f'{{ title = "{title}", url = "{url}", source = NotTheOnion }}')

with open("src/OnionData.elm", "w+") as f:
    f.write(template % "\n        , ".join(out))
