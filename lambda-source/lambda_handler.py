from random import randint
import json
import string


def main(event, context):
    # generate a random word between 5 and 40 characters long
    word = ''.join(
        [string.ascii_lowercase[randint(0, len(string.ascii_lowercase)-1)] for _ in range(randint(5, 40))]
    ).capitalize()

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps(f"I've created a new word: {word}")
    }
