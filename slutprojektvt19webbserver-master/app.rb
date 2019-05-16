require'slim'
require'sqlite3'
require'sinatra'
require 'byebug'
require 'BCrypt'
require_relative 'fil'
enable :sessions
include MyModule

# Display Landing Page
#
get('/') do
    slim(:index)
end

# Attempts login and updates the sessions
#
# @params [String] email, The email
# @params [String] password, The password
#
# @see MyModule#logingin
post('/login') do
    variable = logingin(params["email"], params["password"])
    if variable == nil
        redirect('/')
    else
        session[:id] = variable
        redirect('/lhome')      
    end
end

# Display the create a user page
#
get('/create') do
    slim(:create)
end

# Creates a user then redirects to '/'
#
# @params [String] email, The email asigned to your account
# @params [String] namn, The username asigned to your account
# @params [String] password, The password asigned to your account
#
# @see MyModule#create_user
post('/created') do
    if params["email"].length > 0 && params["password"] == params["password2"] && params["password"].length > 0
        create_user(params["email"],params["namn"],params["password"])
        redirect('/')
    else
        redirect('/error')
    end
    
end

# Displays the logged in home page with all the articles
#
# @see MyModule#getname
# @see MyModule#getallposts_with_votes
get('/lhome') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        session[:name] = getname(session[:id])
        posts = getallposts_with_votes()
        slim(:lhome, locals:{
            posts: posts
        })
    end
end

# Destroys the session and redirects to '/'
#
post('/logout') do
    session.destroy
    redirect('/')
end

# Displays a user profile
#
# @see MyModule#getposts
get('/profile') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        posts = getposts(session[:id])
        slim(:profile, locals:{
            posts: posts
        })
    end
end

# Displays the create post page
#
get('/cpo') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        slim(:cpo)
    end
end

# Creates a post
#
# @params [String] text, The text of the post
# @params [String] img, The imagelink of the post
#
# @see MyModule#createp
post('/createpost') do
    if loggedin(session[:id]) == false
        redirect('/')
    elsif params["text"].length > 0
        createp(session[:id], params["text"], params["img"])    
    else
        redirect("/error")
    end
    redirect('/profile')
end

# Deletes a post from your profile
#
# @params [String] id, The id of the post
#
# @see MyModule#delete
post('/profile/:id/delete') do
    if corlog(session[:id], params["id"]) == false
        redirect('/')
    else
        delete(params["id"])
        redirect('/profile')
    end
end

# Upvotes the post then redirects back
#
# @params [String] id, The id of the post
#
# @see MyModule#vote
get('/lhome/:id/upvote') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        vote(session[:id], params["id"], 1)
        redirect('/lhome')
    end
end

# Downvotes the post then redirects back
#
# @params [String] id, The id of the post
#
# @see MyModule#vote
get('/lhome/:id/downvote') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        vote(session[:id], params["id"], -1)
        redirect('/lhome')
    end
end

get('/profile/:id/edit') do
    if loggedin(session[:id]) == false
        redirect('/')
    else
        result=getsinglepost(params["id"])
        slim(:editpost, locals:{
            post: result
        })
    end
end

post("/update") do
    if corlog(session[:id], params["post_id"]) == false
        redirect('/')
    elsif params["text"].length > 0
        update(params["post_id"], params["text"], params["img"])
    else
        redirect("/error")
    end
    redirect('/profile')
end

get("/error") do
    slim(:error)
end