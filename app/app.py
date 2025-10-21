from flask import Flask

app = Flask(__name__)

@app.route('/')
def show_image():
    return '''
        <html>
            <head><title>Cinnamoroll</title></head>
            <body style="text-align:center; margin-top:50px;">
                <h2>Cinnamoroll</h2>
                <img src="/static/cinnamoroll.jpg" alt="Cinnamoroll" width="800">
            </body>
        </html>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
