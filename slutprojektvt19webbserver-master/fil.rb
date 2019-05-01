require'sqlite3'

def create_user(email, username, password)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    hased_password = BCrypt::Password.create(password)

    db.execute("INSERT INTO users(Email,Name, Password) VAlUES(?,?,?)", email, username, hased_password)
end

def loggedin(sessionid)
    if sessionid == nil
        return false
    end
    return true
end

def logingin(email, password)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    result = db.execute("SELECT Id, Name, Password FROM users WHERE users.Email = ?", email)
    if result.length > 0 && BCrypt::Password.new(result.first["Password"]) == password
        return result.first["Id"]
    end
end

def getname(id)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true
    
    result = db.execute("SELECT Name FROM users WHERE users.Id = ?", id)

    return result.first["Name"]
end

def getposts(id)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    result = db.execute("SELECT Id, Text, Image FROM posts WHERE User_Id = ?", id)

    return result
end

def createp(id,text,img)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    db.execute("INSERT INTO posts(User_Id, Text, Image) VALUES(?, ?, ?)", id, text, img)
end

def delete(id)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    db.execute("DELETE FROM posts WHERE Id = ?", id)
end

def getallposts()
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    result = db.execute("SELECT Id, Text, Image FROM posts")

    return result
end

def votes(up, down)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true
    if up == nil
        result = db.execute("INSERT INTO upvotes(Post_Id, User_Id, Kind)")
    else
        result = db.execute()
    end
end