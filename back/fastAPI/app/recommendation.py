import pandas as pd
import numpy as np
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from scipy.sparse import csr_matrix
from scipy.sparse.linalg import svds
from sklearn.cluster import KMeans
import faiss
from sklearn.decomposition import TruncatedSVD
import matplotlib.pyplot as plt
from sklearn.metrics import silhouette_score
import mysql.connector


# 현재는 코드는 csv 데이터를 기반으로 작성되어있음.
# db에 데이터 삽입 후, db 데이터를 참고 및 수정하는 형식으로 수정 필요

class Recommendation:

    @staticmethod
    def contents():
        df = pd.read_csv("boardgames_bert_improved.csv", sep=",", encoding="latin1")

        df = df.head(1000)

        df["Title"] = df["Title"].fillna("")
        df["description_detail"] = df["description_detail"].fillna("")

        model = SentenceTransformer("stsb-roberta-large")

        sentences = df["description_detail"].astype(str)
        sentence_embeddings = model.encode(sentences.tolist())

        cosine_sim = cosine_similarity(sentence_embeddings, sentence_embeddings)

        conn = mysql.connector.connect(
            # host = "j12d205.p.ssafy.io:3306",
            # user = "d205",
            # password = "jamesboard",
            # database = "D205"
            host="localhost",
            user="root",
            password="",
            database="D205"
        )
        cursor = conn.cursor()

        cursor.execute('''
            CREATE TABLE IF NOT EXISTS game_recommendations (
                game_title VARCHAR(255),
                recommended_game_id INT,
                recommended_game_rating FLOAT
            )
        ''')

        for game_idx, game_name in enumerate(df["Title"]):
            sim_scores = list(enumerate(cosine_sim[game_idx]))
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)[1:101]  
            
            for rank, (idx, _) in enumerate(sim_scores, start=1):  
                recommended_game_id = df["Game_Id"].iloc[idx]
                recommended_game_rating = rank  
                cursor.execute(
                    "INSERT INTO game_recommendations (game_title, recommended_game_id, recommended_game_rating) VALUES (%s, %s, %s)",
                    (game_name, recommended_game_id, recommended_game_rating)
                )
        
        conn.commit()
        cursor.close()
        conn.close()
        print("데이터 삽입 완료")
    

    @staticmethod
    def hybrid():
        pass