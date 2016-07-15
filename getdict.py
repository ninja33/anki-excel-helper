import requests
from bs4 import BeautifulSoup

fr = open('words.txt', 'r')
fw = open('words_out.txt', 'w')
for f in fr:
	r = requests.get('http://dict.cn/' + f.strip())
	soup = BeautifulSoup(r.text,'lxml')
	explanation = soup.find('div', {'class' :'basic clearfix'})
	fw.write(f.strip() + '\t' + explanation)
fr.close()
fw.close()
