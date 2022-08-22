from flask import Flask, render_template, request, jsonify, redirect, url_for
from time import sleep
import psycopg2
import os
import names

app = Flask(__name__)


## Database Configuration
host = os.getenv("DB_HOST")
database = os.getenv("DB_NAME")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWD")

conn = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password
        )

@app.route('/', methods=['GET','POST'])
def index():
    if request.method == 'POST':
        message = request.form.get("message")
        app.logger.info(message)
        save(message)
    return render_template('index.html', data=read())


@app.route('/healthcheck', methods=['GET'])
def health():
    try:
        conn = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password,
            connect_timeout=1
        )
        conn.close()
        return '{ status: OK }'
    except:
        return False
    

@app.route('/limpar', methods=['GET'])
def limpa():
    if request.method == 'GET':
        conn = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password
        )

        db = conn.cursor()
        db.execute("DELETE from messages")
        conn.commit()
        db.close()
        conn.close()
    return redirect(url_for('index'))


@app.route('/popular', methods=['GET','POST'])
def popular():
    for i in range(1000):
        message = names.get_full_name()
        save(message)
    return redirect(url_for('index'))
       

def save(message):
    conn = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password
        )
    cur = conn.cursor()
    sql = "INSERT INTO messages(message) VALUES(%s);"
    cur.execute(sql, (message,))
    conn.commit()
    cur.close()
    conn.close()


def read():
    conn = psycopg2.connect(
           host=host,
           database=database,
           user=user,
           password=password
       )
    db = conn.cursor()
    db.execute("SELECT * FROM messages")
    data = db.fetchall()
    db.close()
    conn.close()
    return data



if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=8000)

