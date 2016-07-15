import requests
from bs4 import BeautifulSoup

fr = open('words.txt', 'r')
fw = open('words_out.txt', 'r')
for f in fr:
    soup = BeautifulSoup(requests.get('http://dict.cn/' + f).text)
    fw.write(f + '\t' + soup.selector(.basic).get_text())
fr.close()
fw.close()
