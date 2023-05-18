import os
import math
from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import login_required

app = Flask(__name__)

app.config["TEMPLATES_AUTO_RELOAD"] = True

app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Heroku change --> db = SQL(os.getenv("postgres://nnaqoxilllabzd:28d116a4901f11a722e6a26d398640a6e811e480c19e61a5c3432db996d04ba7@ec2-18-235-86-66.compute-1.amazonaws.com:5432/d2pjm3l0tvodh2"))

db = SQL("sqlite:///yalieats.db")

@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response

@app.route("/", methods=["GET"])
def home():
    return render_template("before_main2.html")

@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user for an account."""

    # POST
    if request.method == "POST":

        # Validate form submission
        if not request.form.get("first_name"):
            return render_template("missing_firstname.html")
        elif not request.form.get("last_name"):
            return render_template("missing_lastname.html")
        elif not request.form.get("email_address"):
            return render_template("missing_emailaddress.html")
        elif not request.form.get("username"):
            return render_template("missing_username.html")
        elif not request.form.get("password"):
            return render_template("missing_password.html")
        elif request.form.get("password") != request.form.get("confirmation"):
            return render_template("no_match.html")

        substring = "@yale.edu"
        string = request.form.get("email_address")
        if substring in string:
            # add user to the database in the members table
            id = db.execute("INSERT INTO members (first_name, last_name, email_address, username, password) VALUES(?, ?, ?, ?, ?)",
                            request.form.get("first_name"), request.form.get("last_name"), request.form.get("email_address"),request.form.get("username"),
                            generate_password_hash(request.form.get("password")))
        else:
            return render_template("invalid_email.html")



        # return the user to the homepage where they can log in
        return redirect("/")

    # GET
    else:
        return render_template("register.html")

@app.route("/before_main2", methods=["GET"])
def before_main():
    return render_template("before_main2.html")

@app.route("/main", methods=["GET"])
@login_required
def main():
    return render_template("main2.html")

@app.route("/search_by_restaurant", methods=["GET"])
@login_required
def search_by_restaurant():
    return render_template("search_by_restaurant.html")

@app.route("/reviews_static", methods=["GET"])
@login_required
def reviews_static():
    return render_template("reviews.html")

@app.route("/about_us", methods=["GET"])
@login_required
def about_us():
    return render_template("about_us.html")

@app.route("/contact_us", methods=["GET"])
@login_required
def contact_us():
    return render_template("contact_us.html")

@app.route("/your_account", methods=["GET", "POST"])
@login_required
def your_account():

    if request.method == "POST":
        name = db.execute("SELECT restaurant_name FROM restaurants WHERE id = :id", id=request.form.get("id"))
        restaurant_name = name[0]["restaurant_name"]
        reviews = db.execute("SELECT * FROM reviews WHERE memberID = :member_id", member_id=session["member_id"])
        return render_template("your_account.html", restaurant_name=restaurant_name, reviews=reviews)

    else:
        try:
            reviews = db.execute("SELECT * FROM reviews WHERE memberID = :member_id", member_id=session["member_id"])
            return render_template("your_account.html", reviews=reviews)
        except IndexError:
            return render_template("your_empty_account.html")


@app.route("/write_a_review", methods=["GET", "POST"])
@login_required
def write_a_review():
    """Access the form to write a review and actually be able to write and submit a review to the database"""

    # POST
    if request.method == "POST":

        # Validate form submission
        if not request.form.get("restaurant_name"):
            return render_template("missing_restaurant_name.html")

        try:
            restaurant_entry = db.execute("SELECT restaurant_name FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
            restaurant_name = restaurant_entry[0]["restaurant_name"]
        except IndexError:
            return render_template("invalid_restaurant_name.html")

        if not request.form.get("price_rating"):
            return render_template("missing_price_rating.html")
        elif not request.form.get("portion_size_rating"):
            return render_template("missing_portion_size.html")
        elif not request.form.get("recommendation"):
            return render_template("missing_recommendation.html")
        elif not request.form.get("overall_restaurant_rating"):
            return render_template("missing_overall_restaurant_rating.html")
        elif not request.form.get("deliciousness_rating"):
            return render_template("missing_overall_deliciousness_rating.html")
        elif not request.form.get("review_text"):
            return render_template("missing_review_text.html")

        id_entry = db.execute("SELECT id FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        get_id = id_entry[0]["id"]

        new_review = db.execute("INSERT INTO reviews (restaurant_id, memberID, price_rating, portion_size_rating, recommendation, overall_restaurant_rating, deliciousness_rating, review_text) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", get_id, session["member_id"], request.form.get("price_rating"), request.form.get("portion_size_rating"), request.form.get("recommendation"), request.form.get("overall_restaurant_rating"), request.form.get("deliciousness_rating"), request.form.get("review_text"))
        return render_template("main.html")
    # GET
    else:
        return render_template("write_a_review.html")

@app.route("/reviews", methods=["POST"])
@login_required
def reviews():
    """Get the reviews for a restaurant after the user submits the dropdown menu form with their restaurant choice"""
    if not request.form.get("restaurant_name"):
        return render_template("restaurant_empty_error.html")

    try:
        review_entry = db.execute("SELECT price_rating FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
        price_rating = review_entry[0]["price_rating"]
    except IndexError:
        return render_template("no_reviews.html")

    review_entry0 = db.execute("SELECT AVG(price_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
    price_rating = round( review_entry0[0]["AVG(price_rating)"], 1)
    review_entry1 = db.execute("SELECT AVG(portion_size_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
    portion_size_rating = round( review_entry1[0]["AVG(portion_size_rating)"], 1)
    review_entry2 = db.execute("SELECT recommendation FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
    recommendation = review_entry2[0]["recommendation"]
    review_entry3 = db.execute("SELECT AVG(overall_restaurant_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
    overall_restaurant_rating = round( review_entry3[0]["AVG(overall_restaurant_rating)"], 1)
    review_entry4 = db.execute("SELECT AVG(deliciousness_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
    deliciousness_rating = round( review_entry4[0]["AVG(deliciousness_rating)"], 1)
    review_entry5 = db.execute("SELECT review_text FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
    review_text = review_entry5[0]["review_text"]
    restaurant_entry = db.execute("SELECT restaurant_name FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
    restaurant_name = restaurant_entry[0]["restaurant_name"]
    bang_for_buck_rating = round((.35 * portion_size_rating + .35 * price_rating + .30 * deliciousness_rating), 1)

    return render_template("review_result.html", restaurant_name=restaurant_name, price_rating=price_rating, portion_size_rating=portion_size_rating, recommendation=recommendation, overall_restaurant_rating=overall_restaurant_rating, deliciousness_rating=deliciousness_rating, review_text=review_text, bang_for_buck_rating=bang_for_buck_rating)


@app.route("/search_for_restaurant", methods=["POST"])
@login_required
def search_for_restaurant():
    """Allows the user to enter a restaurant name and get information about it"""
    if not request.form.get("restaurant_name"):
        return render_template("restaurant_empty_error.html")

    restaurant_entry = db.execute("SELECT restaurant_name FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
    if not restaurant_entry:
        return render_template("restaurant_search_error.html")
    else:
        restaurant_name = restaurant_entry[0]["restaurant_name"]
        restaurant_entry1 = db.execute("SELECT address FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        address = restaurant_entry1[0]["address"]
        restaurant_entry2 = db.execute("SELECT phone_number FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        phone_number = restaurant_entry2[0]["phone_number"]
        restaurant_entry3 = db.execute("SELECT type_of_food FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        type_of_food = restaurant_entry3[0]["type_of_food"]
        restaurant_entry4 = db.execute("SELECT restaurant_vibe FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        restaurant_vibe = restaurant_entry4[0]["restaurant_vibe"]
        restaurant_entry5 = db.execute("SELECT on_snackpass FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        on_snackpass = restaurant_entry5[0]["on_snackpass"]
        restaurant_entry6 = db.execute("SELECT id FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        current_id = restaurant_entry6[0]["id"]

        try:
            review_entry = db.execute("SELECT price_rating FROM reviews WHERE restaurant_id = :id", id=current_id)
            price_rating = review_entry[0]["price_rating"]
        except IndexError:
            return render_template("restaurant_result.html", name=restaurant_name, address=address, phone_number=phone_number, type_of_food=type_of_food, restaurant_vibe=restaurant_vibe, on_snackpass=on_snackpass, five_star_rating="N/A", number_of_reviews="0", percentage="N/A", bang_for_buck_rating="N/A", price_rating="N/A", deliciousness_rating="N/A", portion_size_rating="N/A")

        review_entry1 = db.execute("SELECT AVG(overall_restaurant_rating) FROM reviews WHERE restaurant_id = :id", id=current_id)
        overall_restaurant_rating = round( review_entry1[0]["AVG(overall_restaurant_rating)"], 1)
        five_star_rating = overall_restaurant_rating / 2
        review_entry2 = db.execute("SELECT COUNT(*) FROM reviews WHERE restaurant_id = :id", id=current_id)
        number_of_reviews = review_entry2[0]["COUNT(*)"]

        review_entry3 = db.execute("SELECT COUNT(*) FROM reviews WHERE recommendation = 'Yes' AND restaurant_id = :id", id=current_id)
        review_entry4 = db.execute("SELECT COUNT(*) FROM reviews WHERE recommendation = 'No' AND restaurant_id = :id", id=current_id)
        yes_reviews = review_entry3[0]["COUNT(*)"]
        no_reviews = review_entry4[0]["COUNT(*)"]

        percentage =  round(((yes_reviews / (yes_reviews + no_reviews) * 100)), 1)
        percent_sign = "%"
        out_of_five = "/ 5.0"


        review_entry = db.execute("SELECT price_rating FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
        price_rating = review_entry[0]["price_rating"]
        review_entry5 = db.execute("SELECT AVG(price_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
        price_rating = round( review_entry5[0]["AVG(price_rating)"], 1)
        review_entry6 = db.execute("SELECT AVG(portion_size_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
        portion_size_rating = round( review_entry6[0]["AVG(portion_size_rating)"], 1)
        review_entry9 = db.execute("SELECT AVG(deliciousness_rating) FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
        deliciousness_rating = round( review_entry9[0]["AVG(deliciousness_rating)"], 1)
        review_entry10 = db.execute("SELECT review_text FROM reviews JOIN restaurants ON restaurants.id = reviews.restaurant_id WHERE restaurants.restaurant_name = :name", name=request.form.get("restaurant_name"))
        review_text = review_entry10[0]["review_text"]
        restaurant_entry11 = db.execute("SELECT restaurant_name FROM restaurants WHERE restaurant_name = :name", name=request.form.get("restaurant_name"))
        restaurant_name = restaurant_entry11[0]["restaurant_name"]
        bang_for_buck_rating = round((.35 * portion_size_rating + .35 * price_rating + .30 * deliciousness_rating), 1)


    return render_template("restaurant_result.html", name=restaurant_name, address=address, phone_number=phone_number, type_of_food=type_of_food, restaurant_vibe=restaurant_vibe, on_snackpass=on_snackpass, five_star_rating=five_star_rating, number_of_reviews=number_of_reviews, percentage=percentage, percent_sign=percent_sign, out_of_five=out_of_five, price_rating=price_rating/2, portion_size_rating=portion_size_rating/2, deliciousness_rating=deliciousness_rating/2, bang_for_buck_rating=bang_for_buck_rating/2)


@app.route("/filter_search", methods=["GET","POST"])
@login_required
def filter_search():
    """Let the user filter for restaurant results"""

    if request.method == "POST":

        if request.form.get("type_of_food") !="Choose a Food Type" and request.form.get("on_snackpass") !="Choose a Snackpass Status" and request.form.get("restaurant_vibe") !="Choose a Restaurant Vibe":
            restaurant_results0 = db.execute("SELECT * FROM restaurants WHERE type_of_food = :type AND on_snackpass = :snackpass AND restaurant_vibe = :vibe", type=request.form.get("type_of_food"), snackpass=request.form.get("on_snackpass"), vibe=request.form.get("restaurant_vibe"))
            if not restaurant_results0:
               return render_template("no_filter_results.html")
            else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results0)

        if request.form.get("type_of_food") !="Choose a Food Type" and request.form.get("on_snackpass") =="Choose a Snackpass Status" and request.form.get("restaurant_vibe") =="Choose a Restaurant Vibe":
           restaurant_results1 = db.execute("SELECT * FROM restaurants WHERE type_of_food = :type ORDER BY restaurant_name ASC", type=request.form.get("type_of_food"))
           if not restaurant_results1:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results1)

        if request.form.get("type_of_food") =="Choose a Food Type" and request.form.get("on_snackpass") !="Choose a Snackpass Status" and request.form.get("restaurant_vibe") =="Choose a Restaurant Vibe":
           restaurant_results2 = db.execute("SELECT * FROM restaurants WHERE on_snackpass = :snackpass ORDER BY restaurant_name ASC", snackpass=request.form.get("on_snackpass"))
           if not restaurant_results2:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results2)

        if request.form.get("type_of_food") =="Choose a Food Type" and request.form.get("on_snackpass") =="Choose a Snackpass Status" and request.form.get("restaurant_vibe") !="Choose a Restaurant Vibe":
           restaurant_results3 = db.execute("SELECT * FROM restaurants WHERE restaurant_vibe = :vibe ORDER BY restaurant_name ASC", vibe=request.form.get("restaurant_vibe"))
           if not restaurant_results3:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results3)

        if request.form.get("type_of_food") !="Choose a Food Type" and request.form.get("on_snackpass") !="Choose a Snackpass Status" and request.form.get("restaurant_vibe") =="Choose a Restaurant Vibe":
           restaurant_results4 = db.execute("SELECT * FROM restaurants WHERE type_of_food = :type AND on_snackpass = :snackpass ORDER BY restaurant_name ASC", type=request.form.get("type_of_food"), snackpass=request.form.get("on_snackpass"))
           if not restaurant_results4:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results4)

        if request.form.get("type_of_food") !="Choose a Food Type" and request.form.get("on_snackpass") =="Choose a Snackpass Status" and request.form.get("restaurant_vibe") !="Choose a Restaurant Vibe":
           restaurant_results5 = db.execute("SELECT * FROM restaurants WHERE type_of_food = :type AND restaurant_vibe = :vibe ORDER BY restaurant_name ASC", type=request.form.get("type_of_food"), vibe=request.form.get("restaurant_vibe"))
           if not restaurant_results5:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results5)

        if request.form.get("type_of_food") =="Choose a Food Type" and request.form.get("on_snackpass") !="Choose a Snackpass Status" and request.form.get("restaurant_vibe") !="Choose a Restaurant Vibe":
           restaurant_results6 = db.execute("SELECT * FROM restaurants WHERE on_snackpass = :snackpass AND restaurant_vibe = :vibe ORDER BY restaurant_name ASC", snackpass=request.form.get("on_snackpass"), vibe=request.form.get("restaurant_vibe"))
           if not restaurant_results6:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results6)

        if request.form.get("type_of_food") =="Choose a Food Type" and request.form.get("on_snackpass") =="Choose a Snackpass Status" and request.form.get("restaurant_vibe") =="Choose a Restaurant Vibe":
           restaurant_results7 = db.execute("SELECT * FROM restaurants ORDER BY restaurant_name ASC")
           if not restaurant_results7:
               return render_template("no_filter_results.html")
           else:
               return render_template("filter_search_result.html", restaurant_results=restaurant_results7)

    else:
        return render_template("filter_search.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in."""

    # Forget any member_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return render_template("username_error.html")

        # Ensure password was submitted
        elif not request.form.get("password"):
            return render_template("password_error.html")

        # Query database for username
        rows = db.execute("SELECT * FROM members WHERE username = :username",
                          username=request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) == 0 or not check_password_hash(rows[0]["password"], request.form.get("password")):
            return render_template("login_error.html")

        # Remember which member has logged in
        session["member_id"] = rows[0]["member_id"]

        # Redirect member to main home page for logged-in members
        return redirect("/main")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")

@app.route("/logout")
@login_required
def logout():
    """Log user out."""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/login")