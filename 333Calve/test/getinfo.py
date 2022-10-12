from  bs4 import  BeautifulSoup;
import os
import pandas as pd
import openpyxl

from datamanager import DataManager

db = DataManager()

def listdir(path, list_name):  # Pass in the stored list
    for file in os.listdir(path):
        file_path = os.path.join(path, file)
        if os.path.isdir(file_path):
            listdir(file_path, list_name)
        else:
            list_name.append(file_path)

list_name=[]
path='E:/333E/Testsite_group_1/'   #My own absolute folder path
listdir(path,list_name)
# print(list_name)

s = [[]]
cnt=0
for file in list_name: #Traversing folders
     if not os.path.isdir(file):
         if file[len(file)-5:len(file)] == ".html" :
             # print(file)
             cnt+=1
             with open(file, 'r',encoding='ISO-8859-1')as wb_data: #python to open local web files
                Soup = BeautifulSoup(wb_data, 'lxml')  #Create the Soup object and subsequently select the desired part with the select function
                caption = Soup.select('head > title ')
                if len(caption) !=0:
                    # s_item=[]
                    # print(caption[0].get_text())
                    # s_item.append(file)
                    # s_item.append(caption[0].get_text())
                    # s.append(s_item) #The text of each file is stored in a list
                    data = (cnt,file,caption[0].get_text())
                    db.save_data(data)
                else:
                    # s_item=[]
                    # print('')
                    # s_item.append(file)
                    # s_item.append('')#If there is no title, nothing is added
                    # s.append(s_item)
                    data = (cnt,file,'')
                    db.save_data(data)


# print(s) #Print Results
# df=pd.DataFrame(s)
# df.to_excel("./data_test.xlsx")
