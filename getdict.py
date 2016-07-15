import requests
from bs4 import BeautifulSoup
fr = open('words.txt', 'r')
fw = open('words_out.txt', 'w')
for f in fr:
    fw.write(f.strip() + '\t' + BeautifulSoup(requests.get('http://dict.cn/' + f.strip()).text).find('div',{'class' :'basic clearfix'}))
fr.close()
fw.close()
