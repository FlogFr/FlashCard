#!/usr/bin/env python3

import psycopg2
import anosql
import random
import time
import os


def main():
    with psycopg2.connect('service=words') as db_conn:
        queries = anosql.load_queries('postgres', 'queries.sql')

        # Let's print 5 random words we want to work on,
        # with the definition
        random_words = queries.get_n_random_words(db_conn, n=5)
        print('Words to keep in mind are:')
        for random_word in random_words:
            print('{} "{}": {}'.format(random_word[0], random_word[1], random_word[2]))

        time.sleep(10)
        os.system('cls' if os.name == 'nt' else 'clear')

        # And now let's do a simple question
        random_word = random.choice(random_words)

        answer = input('Word in {} for {}:\n--> '.format(random_word[0], random_word[2]))
        similarity = queries.get_similarity_word(db_conn, word_try=answer, word=random_word[1])[0][0]
        if similarity > 0.05:
            print('Cool! Again?')
        else:
            print('Almost there… The good word was: {}\nKeep trying!'.format(random_word[1]))
        pass


if __name__ == '__main__':
    main()
