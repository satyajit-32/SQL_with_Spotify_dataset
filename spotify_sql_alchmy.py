from sqlalchemy import create_engine
import pandas as pd

engine = create_engine("mysql+mysqldb://root:root@localhost/spotify")
conn=engine.connect()

data = pd.read_csv("D:/Naresh_IT/CampusX/SQL/Projects/Spotify/spotify_cleaned.csv")
data.to_sql("spotify",engine,index=False,if_exists="replace")
conn.close()