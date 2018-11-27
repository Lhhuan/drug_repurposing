try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.cElementTree as ET

# f_input = open('./1.xml')

# eTree = ET.parse(f_input)

# root = ET.parse('./1.xml')
# books = root.findall('./list')
# for book_list in books :
#     print ('='* 30)
#     for book in book_list:
#         if id in book.attrib:
#             print ('id:',book.attrib['id'])
#         print (book.tag + '==>'+ book.text)
# print ('='*30)



root = ET.parse('./1.xml')
info = root.findall('./list')
for intro in info :
    print ('='* 30)
    if id in intro.attrib:
        print ('id:',intro.attrib['id'])
    for book in intro :
        print (book.tag + '==>'+ book.text)
print ('='*30)