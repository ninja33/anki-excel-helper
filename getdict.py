import requests
from bs4 import BeautifulSoup
fr = open('words.txt', 'r')
fw = open('words_out.txt', 'w')
for f in fr:
    fw.write(f + '\t' + BeautifulSoup(requests.get('http://dict.cn/' + f).text).selector(.basic).get_text())
fr.close()
fw.close()
