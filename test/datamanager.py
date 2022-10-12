# mysql database server, port: 3306, and the server is in startup state
import pymysql
import threading
from test.settings import MYSQL_HOST,MYSQL_DB,MYSQL_PWD,MYSQL_USER

class DataManager():

    # Singleton pattern, ensuring that one object is called each time it is instantiated
    _instance_lock = threading.Lock()
    def __new__(cls, *args, **kwargs):
        if not hasattr(DataManager,"_instance"):
            with DataManager._instance_lock:
                DataManager._instance = object.__new__(cls)
                return DataManager._instance

        return DataManager._instance

    def __init__(self):
        try:
            # Build connection
            self.conn = pymysql.connect(host=MYSQL_HOST,user=MYSQL_USER,password=MYSQL_PWD,database=MYSQL_DB,charset='utf8')
        except pymysql.Error as e:
            print("Database connection failure："+str(e))
        # Create Cursor
        self.cursor = self.conn.cursor()

    def save_data(self,data):
        # Database Operations
        # Define a formatted sql statement
        sql = 'insert into test(id,url,caption) values(%s,%s,%s) '

        try:
            self.cursor.execute(sql,data)
            self.conn.commit()
        except Exception as e:
            print('Failure to insert data',e)
            self.conn.rollback() #Rollback

    def __del__(self):
        # Close cursor
        self.cursor.close()
        # Close connection
        self.conn.close()
