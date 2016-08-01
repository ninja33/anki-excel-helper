from bs4 import BeautifulSoup

fr = open("test-r.txt","r")
fw = open("test-w.txt","w")
for line in fr :
    fw.write("this is: \t" + line)
fr.close()
fw.close()

    
