from flask import Flask, request, redirect, render_template
from werkzeug.routing import BaseConverter
from werkzeug.utils import secure_filename
import mysql.connector
import datetime
import os


####################Constants for File Upload Functions###################
UPLOAD_FOLDER = './static/images/'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif', 'JPG'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER 

class RegexConverter(BaseConverter):
	def __init__(self, url_map, *items):
		super(RegexConverter, self).__init__(url_map)
		self.regex = items[0]

app.url_map.converters['regex'] = RegexConverter







# Routing
####################################################
#########        Customer SQL Calls     ############
####################################################
@app.route('/')
def main():
	return render_template('index.html')

@app.route('/customer/')
def customer():
	cnx = connect()
	cursor = cnx.cursor()

	cursor.execute('SELECT idCustomer, FirstName, LastName FROM Customer')
	customers = cursor.fetchall()

	cnx.close()
	return render_template('customer/index.html',
		customers = customers)

@app.route('/customer/login/')
def customer_login():
	cnx = connect()
	cursor = cnx.cursor()
	id = request.args.get('id')

	if get_customer(id, cursor) is None:
		cnx.close()
		return '404 Not found...'

	cnx.close()
	return redirect('./customer/' + id + '/home')

@app.route('/customer/<regex("[0-9]+"):id>/home/')
def customer_home(id):
	cnx = connect()
	cursor = cnx.cursor()

	if get_customer(id, cursor) is None:
		cnx.close()
		return '404 Not found...'

	showings = get_showings(cursor, id,
		request.args.get('title'),
		request.args.getlist('genres'),
		request.args.get('start-date'),
		request.args.get('end-date'),
		request.args.get('seating'))

	cnx.close()

	return render_template('customer/home.html',
		id = id,
		showings = showings)

@app.route('/customer/<regex("[0-9]+"):id>/search/')
def customer_search(id):
	cnx = connect()
	cursor = cnx.cursor()

	if get_customer(id, cursor) is None:
		cnx.close()
		return '404 Not found...'

	genres = get_genres(cursor)

	cnx.close()
	return render_template('customer/search.html',
		genres = genres)

@app.route('/customer/<regex("[0-9]+"):id>/account/')
def customer_account(id):
	cnx = connect()
	cursor = cnx.cursor()
	customers = get_customer(id, cursor)

	if customers is None:
		cnx.close()
		return '404 Not found...'

	showings = get_showings(cursor, id, None, [], None, None, None)

	cnx.close()
	return render_template('customer/account.html',
		customer = customers[0],
		showings = showings)


@app.route('/customer/attend/')
def attend():
	cnx = connect()
	cursor = cnx.cursor()
	cust_id = request.args.get('cust_id')

	cursor.execute('INSERT INTO Attend (Customer_idCustomer, Showing_idShowing) VALUES (%s, %s)', 
		[cust_id, request.args.get('showing_id')])

	cnx.commit()

	cnx.close()
	return redirect('./customer/' + cust_id + '/home')

@app.route('/customer/rate/')
def rate():
	cnx = connect()
	cursor = cnx.cursor()
	cust_id = request.args.get('cust_id')

	cursor.execute('UPDATE Attend SET Rating = %s WHERE (Showing_idShowing = %s AND Customer_idCustomer = %s)',
		[request.args.get('rating'), request.args.get('showing_id'), cust_id])

	cnx.commit()

	cnx.close()
	return redirect('./customer/' + cust_id + '/account')





####################################################
########          Vulnerability Page        ########
####################################################
@app.route('/customer/vulnerable/')
def vulnerable():
	cnx = connect()
	cursor = cnx.cursor()
	title = request.args.get('title')

	showings = []

	if title is not None:
		cursor.execute('SELECT * FROM Showing s JOIN Movie m ON s.Movie_idMovie = m.idMovie WHERE m.MovieName LIKE "%' + title + '%"')
		showings = cursor.fetchall()

	cnx.close()
	return render_template('./customer/vulnerable.html',
		showings = showings)







####################################################
#######              Staff SQL Calls        ########
####################################################

#gets info for lists on the staff page
@app.route('/staff/')
def staff():
	cnx = connect()
	cursor = cnx.cursor()

	cursor.execute('SELECT idMovie, MovieName, MovieYear, MoviePoster FROM Movie;')
	movies = cursor.fetchall()

	cursor.execute('SELECT Genre, MovieName FROM Genre, Movie WHERE Movie_idMovie=idMovie ORDER BY Genre;')
	genres = cursor.fetchall()

	cursor.execute('SELECT RoomNumber, Capacity FROM TheatreRoom;')
	rooms = cursor.fetchall()

	cursor.execute('SELECT idShowing, ShowingDateTime, Movie_idMovie, TheatreRoom_RoomNumber, TicketPrice FROM Showing ORDER BY ShowingDateTime;')
	showings = cursor.fetchall()

	cursor.execute('SELECT idCustomer, FirstName, LastName, EmailAddress, convert(Sex using utf8) FROM Customer ORDER BY LastName;')
	customers = cursor.fetchall()

	cursor.execute('SELECT Customer_idCustomer, Showing_idShowing, Rating, FirstName, LastName FROM Attend, Customer WHERE Customer_idCustomer=idCustomer;')
	attendWithNames = cursor.fetchall()

	cursor.execute('SELECT Customer_idCustomer, Showing_idShowing, Rating, idShowing, ShowingDateTime FROM Attend, Showing WHERE Showing_idShowing=idShowing;')
	attendWithShowings = cursor.fetchall()

	cursor.execute('SELECT Customer_idCustomer, Showing_idShowing, Rating, MovieName FROM Attend, Movie WHERE Showing_idShowing=idMovie;')
	attendWithMovieTitle = cursor.fetchall()

	cursor.execute('SELECT Customer_idCustomer, Showing_idShowing, Rating FROM Attend ORDER BY Rating DESC;')
	attendWithSortedRatings = cursor.fetchall()

	
	cnx.close()
	return render_template('staff/index.html', movies = movies, genres = genres, rooms = rooms, showings = showings, customers = customers, attendWithNames = attendWithNames, attendWithShowings = attendWithShowings, attendWithMovieTitle = attendWithMovieTitle, attendWithSortedRatings = attendWithSortedRatings)

@app.route('/addmovie/', methods = ['POST'])
def addMovie():
	cnx = connect()
	cursor = cnx.cursor()
	data = [request.form['movieID'], request.form['movieName'], request.form['movieYear'], None]

	if request.files is not None:
		file = request.files['moviePoster']

		if file and allowed_file(file.filename):
			filename = secure_filename(file.filename)
			file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
			data[3] = filename

	query = "INSERT INTO Movie(idMovie, MovieName, MovieYear, moviePoster) VALUES( %s, %s, %s, %s);"
	cursor.execute(query, data)

	cnx.commit()
	cnx.close()
	return redirect("./staff/")

@app.route('/deletemovie/', methods=['POST'])
def deleteMovie():
	cnx = connect()
	cursor = cnx.cursor()

	data=request.form['movieID']

	query = "DELETE FROM Genre WHERE Movie_idMovie=%s;"
	cursor.execute(query, (data,))

	query = "DELETE FROM Showing WHERE Movie_idMovie=%s;"
	cursor.execute(query, (data,))

	query = "DELETE FROM Movie WHERE idMovie=%s;"
	cursor.execute(query, (data,))

	cnx.commit()
	cnx.close()
	return redirect("./staff/")

@app.route('/modifymovie/', methods=['POST'])
def modifyMovie():
	cnx = connect()
	cursor = cnx.cursor()

	data= [request.form['movieID'], request.form['movieName'], request.form['movieYear'], None]
	
	if data[1] != None and data[1] != "":
		tempData=(request.form['movieName'], request.form['movieID'])
		query = "UPDATE Movie SET MovieName=%s WHERE idMovie=%s"
		cursor.execute(query, tempData)
		cnx.commit()
	if data[2] != None and data[2] != "":
		tempData=(request.form['movieYear'], request.form['movieID'])
		query = "UPDATE Movie SET MovieYear=%s WHERE idMovie=%s"
		cursor.execute(query, tempData)
		cnx.commit()

	if request.files is not None:
		file = request.files['moviePoster']
		
		if file and allowed_file(file.filename):
			filename = secure_filename(file.filename)
			file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
			tempData = (filename, data[0])
			query = "UPDATE Movie SET moviePoster=%s WHERE idMovie=%s"
			cursor.execute(query,tempData)
			cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/addgenre/', methods=['POST'])
def addgenre():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['genre'], request.form['movieID'])
	
	if data[1] != None and data[1] != "":
		query = "INSERT INTO Genre(Genre, Movie_idMovie) VALUES(%s, %s);"
		cursor.execute(query, data)
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/deletegenre/', methods=['POST'])
def deletegenre():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['movieID'])
	
	if data[0] != None and data[0] != "":
		query = "DELETE FROM Genre WHERE Movie_idMovie=%s;"
		cursor.execute(query, (data,))
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/addroom/', methods=['POST'])
def addroom():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['roomNumber'], request.form['roomCapacity'])
	
	if data[0] != None and data[0] != "" and data[1] != None and data[1] != "":
		query = "INSERT INTO TheatreRoom(RoomNumber, Capacity) VALUES(%s, %s);"
		cursor.execute(query, data)
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/deleteroom/', methods=['POST'])
def deleteroom():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['roomNumber'])
	
	if data[0] != None and data[0] != "":

		query = "DELETE FROM Showing WHERE TheatreRoom_roomNumber=%s;"
		cursor.execute(query, (data,))
		
		query = "DELETE FROM TheatreRoom WHERE roomNumber=%s;"
		cursor.execute(query, (data,))
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/modifyroom/', methods=['POST'])
def modifyroom():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['roomCapacity'], request.form['roomNumber'])
	
	if data[0] != None and data[0] != "":
		query = "UPDATE TheatreRoom Set Capacity=%s WHERE RoomNumber=%s;"
		cursor.execute(query, data)
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/addshowing/', methods=['POST'])
def addshowing():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['showingID'], request.form['showingDateTime'], request.form['movieID'], request.form['roomNumber'], request.form['showingPrice'])
	
	if data[0] != None and data[0] != "" and data[1] != None and data[1] != "":
		query = "INSERT INTO Showing(idShowing, ShowingDateTime, Movie_idMovie, TheatreRoom_RoomNumber, TicketPrice) VALUES(%s, %s, %s, %s, %s);"
		cursor.execute(query, data)
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/deleteshowing/', methods=['POST'])
def deleteshowing():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['showingID'], request.form['movieID'], request.form['roomNumber'])
	
	if data[0] != None and data[0] != "" and data[1] != None and data[1] != "" and data[2] != None and data[2] != "":
		query = "DELETE FROM Showing WHERE idShowing=%s and Movie_idMovie=%s and TheatreRoom_RoomNumber=%s;"
		cursor.execute(query, (data))
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/modifyshowing/', methods=['POST'])
def modifyshowing():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['showingID'], request.form['showingDateTime'], request.form['movieID'], request.form['roomNumber'], request.form['showingPrice'])
	
	if data[0] != None and data[0] != "" and data[2] != None and data[2] != "" and data[3] != None and data[3] != "":
		if data[1] != None and data[1] != "":
			tempData = (request.form['showingDateTime'], request.form['showingID'], request.form['movieID'], request.form['roomNumber'])
			query = "UPDATE Showing Set ShowingDateTime=%s WHERE idShowing=%s and Movie_idMovie=%s and TheatreRoom_RoomNumber=%s;"
			cursor.execute(query, tempData)
			cnx.commit()

		if data[4] != None and data[4] != "":
			tempData = (request.form['showingPrice'], request.form['showingID'], request.form['movieID'], request.form['roomNumber'])
			query = "UPDATE Showing Set TicketPrice=%s WHERE idShowing=%s and Movie_idMovie=%s and TheatreRoom_RoomNumber=%s;"
			cursor.execute(query, tempData)
			cnx.commit()
	
	cnx.close()
	return redirect("./staff/")


@app.route('/addcustomer/', methods=['POST'])
def addcustomer():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['customerID'], request.form['firstName'], request.form['lastName'], request.form['email'], request.form['sex'])
	
	if data[0] != None and data[0] != "" :
		query = "INSERT INTO Customer(idCustomer, FirstName, LastName, EmailAddress, Sex) VALUES(%s, %s, %s, %s, %s);"
		cursor.execute(query, data)
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/deletecustomer/', methods=['POST'])
def deletecustomer():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['idCustomer'])
	
	if data[0] != None and data[0] != "":
		query = "DELETE FROM Customer WHERE idCustomer=%s;"
		cursor.execute(query, (data,))
		cnx.commit()
	
	cnx.close()
	return redirect("./staff/")

@app.route('/modifycustomer/', methods=['POST'])
def modifycustomer():
	cnx = connect()
	cursor = cnx.cursor()

	data=(request.form['customerID'], request.form['firstName'], request.form['lastName'], request.form['email'], request.form['sex'])
	
	if data[0] != None and data[0] != "":
		if data[1] != None and data[1] != "":
			tempData = (request.form['firstName'], request.form['customerID'])
			query = "UPDATE Customer Set FirstName=%s WHERE idCustomer=%s;"
			cursor.execute(query, tempData)
			cnx.commit()

		if data[2] != None and data[2] != "":
			tempData = (request.form['lastName'], request.form['customerID'])
			query = "UPDATE Customer Set LastName=%s WHERE idCustomer=%s;"
			cursor.execute(query, tempData)
			cnx.commit()

		if data[3] != None and data[3] != "":
			tempData = (request.form['email'], request.form['customerID'])
			query = "UPDATE Customer Set EmailAddress=%s WHERE idCustomer=%s;"
			cursor.execute(query, tempData)
			cnx.commit()


		if data[4] != None and data[4] != "":
			tempData = (request.form['sex'], request.form['customerID'])
			query = "UPDATE Customer Set Sex=%s WHERE idCustomer=%s;"
			cursor.execute(query, tempData)
			cnx.commit()
	
	cnx.close()
	return redirect("./staff/")






####################################################
########          Helper Functions          ########
####################################################
def connect():
	return mysql.connector.connect(user = 'root', database = 'MovieTheatre')

def get_customer(id, cursor):
	cursor.execute('SELECT * FROM Customer WHERE idCustomer = %s', [id])
	result = cursor.fetchall()

	if len(result) == 0:
		return None
	return result

def get_genres(cursor):
	cursor.execute('SELECT Genre FROM Genre GROUP BY Genre')
	return cursor.fetchall()

def get_showings(cursor, id, title, genres, start, end, seating):
	_select = [
		's.idShowing AS id',
		'DATE_FORMAT(s.ShowingDateTime, "%Y%m%d")',
		'DATE_FORMAT(s.ShowingDateTime, "%M %d, %Y") AS date',
		'DATE_FORMAT(s.ShowingDateTime, "%r") AS time',
		's.TicketPrice AS price',
		'm.MovieName AS name',
		'm.MovieYear AS year',
		'm.MoviePoster AS poster',
		't.Capacity AS capacity',
		'g.Genre'
	]

	_from = [
		'Showing s',
		'Movie m',
		'Genre g',
		'TheatreRoom t'
	]

	_on = [
		's.Movie_idMovie = m.idMovie',
		'g.Movie_idMovie = m.idMovie',
		's.TheatreRoom_RoomNumber = t.RoomNumber'
	]

	conditions = []
	genre_conditions = []
	_where = ''

	if title is not None and len(title) is not 0:
		conditions.append('m.MovieName LIKE "%%%s%%"' %title)

	if genres is not None and len(genres) is not 0:
		for genre in genres:
			genre_conditions.append('"%s"' %genre)
		conditions.append('g.Genre IN (' + ', '.join(genre_conditions) + ')')

	if start is not None and len(start) is not 0:
		start = datetime.datetime.strptime(start, '%d %B, %Y').strftime('%Y%m%d')
		conditions.append('s.ShowingDateTime >= "%s"' %start)

	if end is not None and len(end) is not 0:
		end = datetime.datetime.strptime(end, '%d %B, %Y').strftime('%Y%m%d')
		conditions.append('s.ShowingDateTime <= "%s"' %end)

	if len(conditions) is not 0:
		_where += ' WHERE ' + ' AND '.join(conditions)

	query = 'SELECT ' + ', '.join(_select) + ' FROM ' + ' JOIN '.join(_from) + ' ON (' + ' AND '.join(_on) + ')' + _where
	t1 = 'SELECT *, COUNT(*) As genres FROM (' + query + ') t1 GROUP BY id'

	_select.append('a.Customer_idCustomer AS cust_id')
	_select.append('a.Rating AS rating')
	
	_from.append('Attend a')

	_on.append('a.Showing_idShowing = s.idShowing')

	query = 'SELECT ' + ', '.join(_select) + ' FROM ' + ' JOIN '.join(_from) + ' ON (' + ' AND '.join(_on) + ')' + _where

	t2 = 'SELECT * FROM (' + query + ') t2 GROUP BY id, cust_id'

	t3 = 'SELECT *, COUNT(*) AS attending FROM (' + t2 + ') t WHERE cust_id = %s GROUP BY id' %id
	
	t2 = 'SELECT *, COUNT(*) AS attendees FROM (' + t2 + ') t2 GROUP BY id'

	_select = [
		'COALESCE(t2.id, t3.id) AS id',
		'COALESCE(t2.date, t3.date) AS date',
		'COALESCE(t2.time, t3.time) AS time',
		'COALESCE(t2.price, t3.price) AS price',
		'COALESCE(t2.name, t3.name) AS name',
		'COALESCE(t2.year, t3.year) AS year',
		'COALESCE(t2.poster, t3.poster) AS poster',
		't2.attendees AS attendees',
		't3.attending AS attending',
		't3.rating AS rating'
	]

	left = 'SELECT ' + ', '.join(_select) + ' FROM (' + t2 + ') t2 LEFT JOIN (' + t3 + ') t3 ON t2.id = t3.id'
	right = 'SELECT ' + ', '.join(_select) + ' FROM (' + t2 + ') t2 RIGHT JOIN (' + t3 + ') t3 ON t2.id = t3.id'
	query = 'SELECT * FROM (' + left + ' UNION ALL ' + right + ') t GROUP BY id'

	t2 = query

	_select = [
		'COALESCE(t1.id, t2.id) AS id',
		'COALESCE(t1.date, t2.date) AS date',
		'COALESCE(t1.time, t2.time) AS time',
		'COALESCE(t1.price, t2.price) AS price',
		'COALESCE(t1.name, t2.name) AS name',
		'COALESCE(t1.year, t2.year) AS year',
		't2.attendees AS attendees',
		't1.capacity AS capacity',
		't2.attending AS attending',
		't2.rating As rating',
		'COALESCE(t1.poster, t2.poster) AS poster',
		't1.genres'
	]

	left = 'SELECT ' + ', '.join(_select) + ' FROM (' + t1 + ') t1 LEFT JOIN (' + t2 + ') t2 ON t1.id = t2.id'
	right = 'SELECT ' + ', '.join(_select) + ' FROM (' + t1 + ') t1 RIGHT JOIN (' + t2 + ') t2 ON t1.id = t2.id'
	query = 'SELECT * FROM (' + left + ' UNION ALL ' + right + ') t GROUP BY id'

	if seating == 'on':
		query = 'SELECT * FROM (' + query + ') t WHERE capacity > attendees'

	if len(genres) > 1:
		query = 'SELECT * FROM (' + query + ') t WHERE genres = ' + str(len(genres))

	print(query)

	cursor.execute(query)
	return cursor.fetchall()

#Checks that a file is valid from the file form inputs
def allowed_file(filename):
	return '.' in filename and \
		   filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

if __name__ == '__main__':
	app.run(host = '0.0.0.0', debug = True)
	