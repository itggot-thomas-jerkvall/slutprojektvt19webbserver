require'sqlite3'
require 'BCrypt'

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
    #db.results_as_hash = true

    db.execute("INSERT INTO posts(User_Id, Text, Image) VALUES(?, ?, ?)", id, text, img)
    max = db.execute("SELECT MAX(Id) FROM posts")
    db.execute("INSERT INTO upvotes(Post_Id, User_Id, Kind) VALUES(?, ?, 0)",  max.first[0], id)
end

def delete(id)
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    db.execute("DELETE FROM posts WHERE Id = ?", id)
end

def getallposts_with_votes()
    db = SQLite3::Database.new("db/reddit.db")
    db.results_as_hash = true

    #result = db.execute("SELECT posts.Id, Text, Image, SUM(upvotes.Kind) AS score FROM posts INNER JOIN upvotes ON posts.Id = upvotes.Post_Id")
    result = db.execute("SELECT posts.Id, Text, Image, SUM(DISTINCT upvotes.Kind ) AS score FROM posts INNER JOIN upvotes WHERE upvotes.Post_Id = posts.Id GROUP BY posts.Id")
    return result
end

def vote(session, postid, kind)
    db = SQLite3::Database.new("db/reddit.db")
    result=db.execute("SELECT SUM(Kind) FROM upvotes WHERE User_Id = ? AND Post_Id = ?", session, postid)
    p result.first[0]
    if result.first[0] == 0 || result.first[0] == nil
        db.execute("INSERT INTO upvotes(User_Id, Post_Id, Kind) VALUES(?,?,?)", session, postid, kind)
    else
        db.execute("UPDATE upvotes SET Kind = 0 WHERE User_Id = ? AND Post_Id = ?", session, postid)
    end
end

#def getallkind()
#    db = SQLite3::Database.new("db/reddit.db")
#    db.results_as_hash = true
#    result = db.execute("SELECT SUM(Kind) FROM upvotes")
#    return result
#end