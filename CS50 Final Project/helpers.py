import os
import requests
import urllib.parse

from flask import redirect, session
from functools import wraps

def login_required(f):
    """
    Require the user to log in to access the pages that have this integrated

    http://flask.pocoo.org/docs/0.12/patterns/viewdecorators/
    """
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("member_id") is None:
            return redirect("/login")
        return f(*args, **kwargs)
    return decorated_function