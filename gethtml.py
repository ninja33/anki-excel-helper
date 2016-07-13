#coding=utf-8
 
import urllib2
from ntlm import HTTPNtlmAuthHandler
import re
 
def downloadPage(url):
    user = ''
    password = ''

    passman = urllib2.HTTPPasswordMgrWithDefaultRealm()
    passman.add_password(None, url, user, password)
    #proxy = urllib2.ProxyHandler({'http': 'user:pass@proxy.com:8080'})
    #auth = urllib2.HTTPBasicAuthHandler()
    auth_NTLM = HTTPNtlmAuthHandler.HTTPNtlmAuthHandler(passman)
    opener = urllib2.build_opener(auth_NTLM)
    urllib2.install_opener(opener)
    return urllib2.urlopen(url).read()
 
def downloadImg(content):
    print content
    pattern = r'src="(.+?\.jpg)" pic_ext'
    m = re.compile(pattern)
    urls = re.findall(m, content)
    print urls
    for i, url in enumerate(urls):
        urllib.urlretrieve(url, "%s.jpg" % (i, ))
 
content = downloadPage("http://tieba.baidu.com/p/2460150866")
downloadImg(content)
