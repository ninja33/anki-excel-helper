# -*- coding:utf-8 -*-
import sys
import requests
from bs4 import BeautifulSoup


def main():
    reload(sys)
    sys.setdefaultencoding('utf-8')

    fr = open('words.txt', 'r')
    fw = open('words_out.txt', 'w')
    for f in fr:
        r = requests.get('http://dict.cn/' + f.strip())
        soup = BeautifulSoup(r.text, 'lxml')
        phonetic = soup.find('div', {'class': 'phonetic'})
        p = ''
        for sp in phonetic.find_all('span'):
            if sp is not None:
                p = p + unicode(sp.text.strip()) + '&nbsp'

        explanation = soup.find('div', {'class': 'basic clearfix'})
        e = ''
        for l in explanation.find_all('li'):
            if l.span is not None:
                e = e + unicode(l.span.text) + "&nbsp;"
            if l.strong is not None:
                e = e + unicode(l.strong.text) + "&nbsp;"
        # print f.strip() + '\t' + p + '\t' + e + '\n'
        fw.write(f.strip() + '\t' + p + '\t' + e + '\n')
    fr.close()
    fw.close()

if __name__ == '__main__':
    main()
